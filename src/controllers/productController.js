const {
  getProducts,
  getProductById,
  getProductsByCategories,
  getProductsByUser,
  createProduct,
  addCategory,
  updateProduct,
  deleteProduct,
  ratingProduct,
  getRating,
  updateRating,
  updateCategory,
} = require("../models/products");

const all = async (req, res) => {
  try {
    const queryStrings = req.query;
    const products = await getProducts(queryStrings);
    res.status(200).json(products);
  } catch (error) {
    console.error("Error al obtener todos los productos:", error);
    res.status(500).json({ error: error.message });
  }
};
const one = async (req, res) => {
  try {
    const product = await getProductById(req.params.id);
    res.status(200).json(product);
  } catch (error) {
    console.error("Error al obtener el producto:", error);
    res.status(500).json({ error: error.message });
  }
};
const productsByCategories = async (req, res) => {
  try {
    let page = parseInt(req.query.page) || 1;
    if (page < 1) page = 1;
    const category = req.params.category;
    const products = await getProductsByCategories(page, category);
    res.status(200).json(products);
  } catch (error) {
    console.error("Error al obtener los productos por categoria:", error);
    res.status(500).json({ error: error.message });
  }
};
const productsByUser = async (req, res) => {
  try {
    const user_id = req.params.id;
    const userProducts = await getProductsByUser(user_id);
    res.status(200).json(userProducts);
  } catch (error) {
    console.error("Error al obtener los productos del usuario:", error);
    res.status(500).json({ error: error.message });
  }
};
const create = async (req, res) => {
  try {
    const product = await createProduct(req.body);
    await addCategory(product.product_id, req.body.category);
    res.status(200).json(product);
  } catch (error) {
    console.error("Error al crear el producto:", error);
    res.status(500).json({ error: error.message });
  }
};
const update = async (req, res) => {
  try {
    console.log();
    const product = await updateProduct(req.params.id, req.body);
    await updateCategory(req.params.id, req.body.category);
    res.status(200).json(product);
  } catch (error) {
    console.error("Error al modificar la informacion del producto:", error);
    res.status(500).json({ error: error.message });
  }
};
const destroy = async (req, res) => {
  try {
    const product = await deleteProduct(req.params.id);
    res.status(200).json(product);
  } catch (error) {
    console.error("Error al eliminar el producto:", error);
    res.status(500).json({ error: error.message });
  }
};

const rating = async (req, res) => {
  try {
    const rate = await getRating(req.body);
    if (!rate) {
      const newRate = await ratingProduct(req.body);
      res.status(201).json(newRate);
    } else {
      const updatedRate = await updateRating(req.body);
      res.status(201).json(updatedRate);
    }
  } catch (error) {
    console.error("Error al calificar el producto:", error);
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  all,
  one,
  create,
  update,
  destroy,
  rating,
  productsByCategories,
  productsByUser,
};
