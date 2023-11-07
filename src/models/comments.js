const pool = require('../config/pool');

const commentsByProduct = async (product_id) => {
    const query = 'SELECT * FROM comments WHERE product_id = $1 ORDER BY comment_date ASC';
    try {
        const response = await pool.query(query, [product_id]);
        return response.rows;
    } catch (error) {
        throw new Error(error);
    }
};
const newComment = async (user_id, product_id, content) => {
    const query = 'INSERT INTO comments (user_id, product_id, content) VALUES  ($1, $2, $3)';
    try {
        const response = await pool.query(query,[
            user_id,
            product_id,
            content
        ]);
        return response.rows;
        //NO ESTOY SEGURO SI ESTA LINEA ES NECESARIA
    } catch (error) {
        throw new Error(error);
    }
};
const deleteComment = async (id) => {
    const query = 'DELETE FROM comments WHERE comment_id = $1';
    try {
        const response = await pool.query(query, [id]);
        return response.rows;
    } catch (error) {
        throw new Error(error);
    }
};
const updateComment = async (comment) => {
    const query = 'UPDATE comments SET content = $1 WHERE comment_id = $2';
    try {
        const response = await pool.query(query, [
            comment.content,
            comment.comment_id
        ]);
        return response.rows;
    } catch (error) {
        throw new Error(error);
    }
};


module.exports = { commentsByProduct, newComment, deleteComment, updateComment };