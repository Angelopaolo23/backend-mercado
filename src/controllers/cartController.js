const {
  getProductByID,
  getCartInfo,
  addProduct,
  addOne,
  sustractOne,
  getCarts,
  addOneOrMore,
  deleteProducts,
  removeProduct,
} = require("../models/cart");

const getAll = async (req, res) => {
  try {
    const allCarts = await getCarts();
    res.json(allCarts);
  } catch (error) {
    console.error("Error al obtener todos los carros:", error);
    res.status(500).json({ error: error.message });
  }
};
const oneCart = async (req, res) => {
  try {
    const products = await getCartInfo(req.params.id);
    res.status(200).json(products);
  } catch (error) {
    console.error(
      `Error al obtener el carrito de compras de ID: ${req.params.id}`,
      error
    );
    res.status(500).json({ error: error.message });
  }
};
const add = async (req, res) => {
  try {
    const product = await getProductByID(req.body);
    if (!product) {
      const newProduct = await addProduct(req.body);
      res.status(201).json(newProduct);
    } else {
      const addingProduct = await addOne(req.body);
      res.status(201).json(addingProduct);
    }
  } catch (error) {
    console.error("Error al agregar un producto al carro:", error);
    res.status(500).json({ error: error.message });
  }
};
const sustract = async (req, res) => {
  try {
    const product = await getProductByID(req.body);
    if (product) {
      const sustractingProduct = await sustractOne(req.body);
      deleteProducts(req.body.user_id);
      res.status(200).json(sustractingProduct);
    }
  } catch (error) {
    console.error(
      "Error al disminuir cantidad de un producto o eliminarlo del carro:",
      error
    );
    res.status(500).json({ error: error.message });
  }
};
const removeOne = async (req, res) => {
  try {
    const product = await getProductByID(req.body);
    if (product) {
      const removingProduct = await removeProduct(req.body);
      res
        .status(200)
        .json("Producto removido exitosamente del carro:", removingProduct);
    }
  } catch (error) {
    console.error("Error al eliminar producto del carro:", error);
    res.status(500).json({ error: error.message });
  }
};

module.exports = { getAll, oneCart, add, sustract, removeOne };
