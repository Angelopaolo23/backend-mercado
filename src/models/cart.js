const pool = require("../config/pool");

const getProductByID = async (product) => {
  const query =
    "SELECT * FROM shopping_cart WHERE user_id = $1 AND product_id = $2";
  try {
    const response = await pool.query(query, [
      product.user_id,
      product.product_id,
    ]);
    return response.rows[0];
  } catch (error) {
    throw new Error(error);
  }
};
const existCart = async (id) => {
  const query = "SELECT EXISTS(SELECT 1 FROM shopping_cart WHERE user_id = $1)";
  try {
    const response = await pool.query(query, [id]);
    return response.rows[0].exists;
  } catch (error) {
    throw new Error(error);
  }
};
const getCartInfo = async (id) => {
  //NECESITO EL NOMBRE DEL ARTISTA (username) DE LA TABLA PRODUCTS y USER (products.seller_id = users.user_id), ADEMAS NECESITO LAS CATEGORIAS DEL PRODUCTO
  const query =
    "SELECT shopping_cart.product_id, products.title, shopping_cart.quantity, shopping_cart.price, products.url_image FROM users INNER JOIN shopping_cart ON users.user_id = shopping_cart.user_id INNER JOIN products ON shopping_cart.product_id = products.product_id WHERE shopping_cart.user_id = $1";
  try {
    const response = await pool.query(query, [id]);
    return response.rows;
  } catch (error) {
    throw new Error(error);
  }
};
const addProduct = async (product) => {
  const query =
    "INSERT INTO shopping_cart (user_id, product_id, price, quantity) VALUES ($1, $2, $3, COALESCE($4,1)) RETURNING *";
  try {
    const response = await pool.query(query, [
      product.user_id,
      product.product_id,
      product.price,
      product.quantity,
    ]);
    return response.rows;
  } catch (error) {
    throw new Error(error);
  }
};
const addOne = async (product) => {
  const query =
    "UPDATE shopping_cart SET quantity = quantity + COALESCE($1,1) WHERE user_id = $2 AND product_id = $3 RETURNING *";
  try {
    const response = await pool.query(query, [
      product.quantity,
      product.user_id,
      product.product_id,
    ]);
    return response.rows;
  } catch (error) {
    throw new Error(error);
  }
};
const sustractOne = async (product) => {
  const query =
    "UPDATE shopping_cart SET quantity = quantity - 1 WHERE user_id = $1 AND product_id = $2 RETURNING *";
  try {
    const response = await pool.query(query, [
      product.user_id,
      product.product_id,
    ]);
    return response.rows;
  } catch (error) {
    throw new Error(error);
  }
};
const getCarts = async () => {
  const query = "SELECT * FROM shopping_cart";
  try {
    const response = await pool.query(query);
    return response.rows;
  } catch (error) {
    throw new Error(error);
  }
};
const deleteProducts = async (user_id) => {
  const query =
    "DELETE FROM shopping_cart WHERE user_id = $1 AND quantity <= 0";
  try {
    const response = await pool.query(query, [user_id]);
    return response.rows;
  } catch (error) {
    throw new Error(error);
  }
};
const removeProduct = async (product) => {
  const query =
    "DELETE FROM shopping_cart WHERE user_id = $1 AND product_id = $2";
  try {
    const response = await pool.query(query, [
      product.user_id,
      product.product_id,
    ]);
    return response.rows;
  } catch (error) {
    throw new Error(error);
  }
};

const removeCart = async (user_id) => {
  const query = "DELETE FROM shopping_cart WHERE user_id = $1";
  try {
    const response = await pool.query(query, [user_id]);
    return response.rowCount;
  } catch (error) {
    throw new Error(error);
  }
};

module.exports = {
  getProductByID,
  getCartInfo,
  addProduct,
  addOne,
  sustractOne,
  getCarts,
  deleteProducts,
  removeProduct,
  removeCart,
  existCart,
};
