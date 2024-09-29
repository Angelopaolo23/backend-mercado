import { clearCartAfterCheckout } from "../controllers/cartController";
const {
  getAllOrdersByID,
  addingNewOrder,
  addingOrderItems,
} = require("../models/orders");

const getAll = async (req, res) => {
  try {
    const allOrders = await getAllOrdersByID(req.params.id);
    res.status(200).json(allOrders);
  } catch (error) {
    console.error("Error al obtener todos los carros:", error);
    res.status(500).json({ error: error.message });
  }
};

const add = async (req, res) => {
  try {
    const newOrder = await addingNewOrder(req.params.id);
    if (newOrder) {
      const newItems = await addingOrderItems(
        newOrder.order_id,
        req.body.items
      );
      await clearCartAfterCheckout(req.params.id);
      res.status(201).json({ order_id: newOrder.order_id, items: newItems });
    }
  } catch (error) {
    console.error("Error al agregar productos al carro:", error);
    res.status(500).json({ error: error.message });
  }
};

module.exports = { getAll, add };
