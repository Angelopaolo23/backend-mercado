const pool = require('../config/pool');

const getFavorites = async (user_id) => {
    const query = 'SELECT * FROM favorites WHERE user_id = $1';
    try {
        const { rows } = await pool.query(query, [user_id]);
        return rows;
    } catch (error) {
        throw new Error(error);
    }
};
const newFavorite = async (product_id, user_id) => {
    const query = 'INSERT INTO favorites (user_id, product_id) VALUES ($1, $2) RETURNING *';
    try {
        const response = await pool.query(query, [
            user_id,
            product_id
        ]);
        return response.rows;
    } catch (error) {
        throw new Error(error);
    }
};
const deleteFavorite = async (product_id, user_id) => {
    const query = 'DELETE FROM favorites WHERE user_id = $1 AND product_id = $2';
    try {
        const response = await pool.query(query, [
            user_id,
            product_id
        ]);
        return response.rows;
    } catch (error) {
        throw new Error(error);
    }
};

module.exports = {getFavorites, newFavorite, deleteFavorite};