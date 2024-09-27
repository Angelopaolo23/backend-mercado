const pool = require("../config/pool");
const getAllOrdersByID = async (user_id) => {
  const query = `
      SELECT 
        o.order_id, 
        o.order_date,
        json_agg(
          json_build_object(
            'title', p.title,
            'description', p.description,
            'url_image', p.url_image,
            'quantity', oi.quantity,
            'price', oi.price
          )
        ) as items
      FROM orders o
      INNER JOIN order_items oi ON o.order_id = oi.order_id
      INNER JOIN products p ON p.product_id = oi.product_id
      WHERE o.user_id = $1
      GROUP BY o.order_id, o.order_date
      ORDER BY o.order_date DESC
    `;

  try {
    const response = await pool.query(query, [user_id]);

    const ordersWithItems = response.rows.reduce((acc, order) => {
      acc[order.order_id] = {
        order_date: order.order_date,
        items: order.items,
      };
      return acc;
    }, {});

    return ordersWithItems;
  } catch (error) {
    console.error(`Error obtaining all orders of user: ${user_id}`, error);
    throw new Error(`Error getting orders: ${error.message}`);
  }
};

const addingNewOrder = async (user_id) => {
  const query = "INSERT INTO orders (user_id) VALUES ($1) RETURNING *";
  try {
    const response = await pool.query(query, [user_id]);
    return response.rows[0];
  } catch (error) {
    console.error("Error in addingNewOrder:", error);
    throw new Error(`Error adding new order: ${error.message}`);
  }
};

const addingOrderItems = async (order_id, items) => {
  const query =
    "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES ($1, $2, $3, $4) RETURNING *";

  try {
    const results = await Promise.all(
      items.map((item) =>
        pool.query(query, [
          order_id,
          item.product_id,
          item.quantity,
          item.price,
        ])
      )
    );

    return results.map((result) => result.rows[0]);
  } catch (error) {
    console.error("Error in addingOrderItems:", error);
    throw new Error(`Error adding order items: ${error.message}`);
  }
};

module.exports = { getAllOrdersByID, addingNewOrder, addingOrderItems };
