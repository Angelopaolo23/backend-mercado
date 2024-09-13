const pool = require("../config/pool");

const getFavorites = async (user_id) => {
  const query =
    "SELECT p.*, u.username AS artist FROM products p INNER JOIN favorites f ON p.product_id = f.product_id INNER JOIN users u ON p.seller_id = u.user_id WHERE f.user_id = $1";
  try {
    const { rows } = await pool.query(query, [user_id]);
    return rows;
  } catch (error) {
    throw new Error(error);
  }
};
const getFavoriteById = async (user_id, product_id) => {
  const query =
    "SELECT * FROM favorites WHERE user_id = $1 AND product_id = $2";
  try {
    const response = await pool.query(query, [user_id, product_id]);
    return response.rows[0];
  } catch (error) {
    throw new Error(error);
  }
};
const newFavorite = async (user_id, product_id) => {
  const query =
    "INSERT INTO favorites (user_id, product_id) VALUES ($1, $2) RETURNING *";
  try {
    const response = await pool.query(query, [user_id, product_id]);
    return response.rows;
  } catch (error) {
    throw new Error(error);
  }
};
const deleteFavorite = async (user_id, product_id) => {
  const query = "DELETE FROM favorites WHERE user_id = $1 AND product_id = $2";
  try {
    const response = await pool.query(query, [user_id, product_id]);
    return response.rows;
  } catch (error) {
    throw new Error(error);
  }
};

module.exports = { getFavorites, newFavorite, deleteFavorite, getFavoriteById };
