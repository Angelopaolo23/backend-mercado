const pool = require ('../config/pool');

const getUsers = async () => {
    const query = 'SELECT * FROM users';
    try {
        const response = await pool.query(query);
        return response.rows;
    } catch (error) {
        throw new Error(error);
    }
};

const getUserByID = async (id) => {
    const query = 'SELECT * FROM users WHERE user_id = $1';
    try {
        const response = await pool.query(query, [id]);
        return response.rows[0];
    } catch (error) {
        throw new Error(error);
    }
};

const getUserByUsername = async (username) => {
    const query = 'SELECT * FROM users WHERE username = $1';
    try {
        response = await pool.query(query, [username]);
        return response.rows[0];
    } catch (error) {
        throw new Error(error);
    }
};

const getUserByEmail = async (email) => {
    const query = 'SELECT * FROM users WHERE email = $1';
    try {
        const response = await pool.query(query, [email]);
        return response.rows[0];
    } catch (error) {
        throw new Error(error);
    }
};

module.exports = { getUsers, getUserByID, getUserByUsername, getUserByEmail };