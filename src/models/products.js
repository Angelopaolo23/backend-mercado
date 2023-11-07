const pool = require('../config/pool');

const getProducts = async () => {
    const query = 'SELECT * FROM products';
        try {
            const { rows } = await pool.query(query);
            return rows;
        } catch (error) {
        throw new Error(error);
        }
};
const getProductById = async (id) => {
    const query = 'SELECT * FROM products WHERE product_id = $1';
    try {
        const response = await pool.query(query, [id]);
        return response.rows[0];
    } catch (error) {
        throw new Error(error);
    }
};
const createProduct = async (product) => {
    const query =
      'INSERT INTO products (title, description, price, url_image, seller_id) VALUES ($1, $2, $3, $4, $5) RETURNING *';
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
        throw new Error(error);
    }
};
const addCategory = async (product_id, category_id) => {
    const query = 'INSERT INTO products_categories (product_id, category_id) VALUES ($1, $2)';
    try {
        const response = await pool.query(query, [product_id, category_id]);
        return response.rows;
    } catch (error) {
        throw new Error(error);
    }
};

const updateProduct = async (id, product) => {
    const query =
      'UPDATE products SET title = $1, description = $2, price = $3, url_image = $4 WHERE product_id = $5 RETURNING *';
    try {
        const response = await pool.query(query, [
            product.title,
            product.description,
            product.price, 
            product.url_image, 
            id]);
        return response.rows[0];
    } catch (error) {
        throw new Error(error);
    }
};
const deleteProduct = async (id) => {
    const query = 'DELETE FROM products WHERE product_id = $1';
    try {
        const response = await pool.query(query, [id]);
        return response.rows[0];
    } catch (error) {
        throw new Error(error);
    }
};

module.exports = {getProducts, getProductById, createProduct, addCategory, updateProduct, deleteProduct};