const { getProducts, getProductById, createProduct, addCategory, updateProduct, deleteProduct, ratingProduct, getRating, updateRating, updateCategory} = require('../models/products');

const all = async (req, res) => {
    try {
        const products = await getProducts();
        res.json(products);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
// HAY QUE CORREGIR LA QUERY PARA QUE ENTREGUE LA INFORMACION DE CATEGORIA QUE ES POR SEPARADA A ESTA QUERY QUE SOLO ENTREGA SOBRE EL PRODUCTO
const one = async (req, res) => {
    try {
        const product = await getProductById(req.params.id);
        res.json(product);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
const create = async (req, res) => {
    try {
        const product = await createProduct(req.body);
        await addCategory(product.product_id, req.body.category)
        res.json(product);
    } catch (error) {
        res.status(500).json({error: error.message});
    }
};
const update = async (req, res) => {
    try {
        console.log()
        const product = await updateProduct(req.params.id, req.body);
        await updateCategory(req.params.id, req.body.category);
        res.json(product);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
const destroy = async (req, res) => {
    try {
        const product = await deleteProduct(req.params.id);
        res.json(product);
    } catch (error) {
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
        res.status(500).json({ error: error.message });
    }
};

module.exports = {all, one, create, update, destroy, rating};