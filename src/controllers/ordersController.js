const pool = require("../config/pool");
const { getAllOrdersByID } = require("../models/orders");

const getAll = async (req, res) => {
  try {
    const allOrders = await getAllOrdersByID(req.params.id);
    res.status(200).json(allOrders);
  } catch (error) {
    console.error("Error al obtener todos los pedidos:", error);
    res.status(500).json({ error: error.message });
  }
};
//EN CONTROLLER ADD, SE REALIZA A TRAVES DE TRANSACCIONES DE DB PRIMERO LA CREACION DE UNA ORDEN, Y LUEGO LIMPIAR LOS PRODUCTOS DEL CARRITO
const add = async (req, res) => {
  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    const { id: user_id } = req.params;
    const { items } = req.body;

    if (!user_id || !items || !Array.isArray(items) || items.length === 0) {
      throw new Error("Datos de entrada inválidos");
    }

    const newOrderResult = await client.query(
      "INSERT INTO orders (user_id) VALUES ($1) RETURNING order_id",
      [user_id]
    );
    const newOrderId = newOrderResult.rows[0].order_id;

    for (let item of items) {
      await client.query(
        "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES ($1, $2, $3, $4)",
        [newOrderId, item.product_id, item.quantity, item.price]
      );
    }

    await client.query("DELETE FROM shopping_cart WHERE user_id = $1", [
      user_id,
    ]);

    await client.query("COMMIT");

    res.status(201).json({
      order_id: newOrderId,
      items: items,
      message: "Pedido creado y carrito limpiado con éxito",
    });
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Error al procesar el pedido:", error);
    res.status(500).json({ error: "Error al procesar el pedido" });
  } finally {
    client.release();
  }
};

module.exports = { getAll, add };
