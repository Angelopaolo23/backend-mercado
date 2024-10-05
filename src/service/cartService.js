const { existCart, removeCart } = require("../models/cart");

const clearCart = async (user_id) => {
  try {
    const cartExists = await existCart(user_id);
    if (!cartExists) {
      return {
        success: false,
        message: "No existe un carrito para este usuario",
        itemsRemoved: 0,
      };
    }

    const itemsRemoved = await removeCart(user_id);
    return {
      success: true,
      message:
        itemsRemoved > 0
          ? "Carrito limpiado exitosamente"
          : "El carrito ya estaba vacío",
      itemsRemoved: itemsRemoved,
    };
  } catch (error) {
    console.error(
      `Error al limpiar el carrito para el usuario ${user_id}:`,
      error
    );
    throw new Error("No se pudo limpiar el carrito");
  }
};

module.exports = { clearCart };
