const pool = require("../config/pool");
const getProducts = async () => {
  const query =
    "SELECT p.*, u.username AS artist, c.name AS category FROM products p INNER JOIN products_categories pc ON p.product_id = pc.product_id INNER JOIN categories c ON pc.category_id = c.category_id INNER JOIN users u ON p.seller_id = u.user_id;";
  try {
    const { rows } = await pool.query(query);
    return rows;
  } catch (error) {
    console.error("Error in getProducts:", error);
    throw new Error(`Error fetching all products: ${error.message}`);
  }
};
const getProductsByCategories = async (page = 1, category) => {
  const limits = 12; //productos por pagina
  //si hago filtros para el orden debo pasar el order by a traves de parametros, incluyendo field y direction haciendo split
  const field = "created_at";
  const direction = "DESC";
  const offset = (page - 1) * limits;

  try {
    const query = `SELECT p.*, u.username AS artist, c.name AS category FROM products p INNER JOIN products_categories pc ON p.product_id = pc.product_id INNER JOIN categories c ON pc.category_id = c.category_id INNER JOIN users u ON p.seller_id = u.user_id WHERE c.name = $1 ORDER BY "${field}" ${direction} LIMIT $2 OFFSET $3`;
    const { rows: products } = await pool.query(query, [
      category,
      limits,
      offset,
    ]);

    const countQuery = `
      SELECT COUNT(*) 
      FROM products p
      INNER JOIN products_categories pc ON p.product_id = pc.product_id 
      INNER JOIN categories c ON pc.category_id = c.category_id 
      WHERE c.name = $1
    `;
    const { rows: countResult } = await pool.query(countQuery, [category]);
    const totalProducts = parseInt(countResult[0].count);

    const totalPages = Math.ceil(totalProducts / limits);

    return {
      products,
      metadata: {
        currentPage: page,
        totalPages,
        totalProducts,
        productsPerPage: limits,
      },
    };
  } catch (error) {
    console.error("Error in getCategories:", error);
    throw new Error(`Error fetching categories: ${error.message}`);
  }
};
const getProductById = async (id) => {
  const query = "SELECT * FROM products WHERE product_id = $1";
  try {
    const response = await pool.query(query, [id]);
    return response.rows[0];
  } catch (error) {
    console.error("Error in getProductById:", error);
    throw new Error(`Error fetching product: ${error.message}`);
  }
};
const createProduct = async (product) => {
  const query =
    "INSERT INTO products (title, description, price, url_image, seller_id) VALUES ($1, $2, $3, $4, $5) RETURNING *";
  try {
    const response = await pool.query(query, [
      product.title,
      product.description,
      product.price,
      product.url_image,
      product.seller_id,
    ]);
    return response.rows[0];
  } catch (error) {
    console.error("Error in createProduct:", error);
    throw new Error(`Error creating product: ${error.message}`);
  }
};
const addCategory = async (product_id, category_id) => {
  const query =
    "INSERT INTO products_categories (product_id, category_id) VALUES ($1, $2)";
  try {
    const response = await pool.query(query, [product_id, category_id]);
    return response.rows;
  } catch (error) {
    console.error("Error in addCategory:", error);
    throw new Error(`Error adding a category: ${error.message}`);
  }
};

const updateProduct = async (id, product) => {
  const query =
    "UPDATE products SET title = $1, description = $2, price = $3, url_image = $4 WHERE product_id = $5 RETURNING *";
  try {
    const response = await pool.query(query, [
      product.title,
      product.description,
      product.price,
      product.url_image,
      id,
    ]);
    return response.rows[0];
  } catch (error) {
    console.error("Error in updateProduct:", error);
    throw new Error(`Error updating product: ${error.message}`);
  }
};
const updateCategory = async (id, category) => {
  const query =
    "UPDATE products_categories SET category_id = $1 WHERE product_id = $2 RETURNING *";
  try {
    const response = await pool.query(query, [category, id]);
    return response.rows[0];
  } catch (error) {
    console.error("Error in updateCategory:", error);
    throw new Error(`Error updating category: ${error.message}`);
  }
};
const deleteProduct = async (id) => {
  const query = "DELETE FROM products WHERE product_id = $1";
  try {
    const response = await pool.query(query, [id]);
    return { message: "Product successfully deleted", deletedProduct: rows[0] };
  } catch (error) {
    console.error("Error in deleteProduct:", error);
    throw new Error(`Error deleting product: ${error.message}`);
  }
};

const ratingProduct = async (info) => {
  const query =
    "INSERT INTO product_rating (user_id, product_id, rating) VALUES ($1, $2, $3) RETURNING *";
  try {
    const response = await pool.query(query, [
      info.user_id,
      info.product_id,
      info.rating,
    ]);
    return response.rows;
  } catch (error) {
    console.error("Error in ratingProduct:", error);
    throw new Error(`Error rating product: ${error.message}`);
  }
};
const updateRating = async (info) => {
  const query =
    "UPDATE product_rating SET rating = $1 WHERE user_id = $2 AND product_id = $3";
  try {
    const response = await pool.query(query, [
      info.rating,
      info.user_id,
      info.product_id,
    ]);
    return response.rows;
  } catch (error) {
    console.error("Error in updateRating:", error);
    throw new Error(`Error updating product rate: ${error.message}`);
  }
};
const getRating = async (info) => {
  const query =
    "SELECT * FROM product_rating WHERE user_id = $1 AND product_id = $2";
  try {
    const response = await pool.query(query, [info.user_id, info.product_id]);
    return response.rows[0];
  } catch (error) {
    console.error("Error in getRating:", error);
    throw new Error(`Error fetching product rate: ${error.message}`);
  }
};

module.exports = {
  getProducts,
  getProductById,
  getProductsByCategories,
  createProduct,
  addCategory,
  updateProduct,
  deleteProduct,
  ratingProduct,
  updateRating,
  updateCategory,
  getRating,
};
