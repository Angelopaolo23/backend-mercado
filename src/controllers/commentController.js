const { commentsByProduct, newComment, deleteComment, updateComment } = require('../models/comments');

const oneProduct = async (req, res) => {
    try {
        const comments = await commentsByProduct(req.params.id);
        res.json(comments);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
const create = async (req, res) => {
    try {
        const comment = await newComment(req.body.user_id, req.body.product_id, req.body.content);
        res.json(comment);
    } catch (error) {
        res.status(500).json({error: error.message});
    }
};
const destroy = async (req, res) => {
    try {
        const comment = await deleteComment(req.body.comment_id);
        res.json(comment);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
const update = async (req, res) => {
    try {
        const comment = await updateComment(req.body);
        res.json(comment);
    } catch (error) {
        res.status(500).json({ error: error.message })
    }
};
module.exports = {oneProduct, create, destroy, update};