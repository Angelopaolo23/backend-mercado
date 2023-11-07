const { getProducts, getProductById, createProduct, addCategory, updateProduct, deleteProduct} = require('../models/products');

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
//HAY QUE AGREGAR LA PARTE DE ACTUALIZAR LAS CATEGORIAS
const update = async (req, res) => {
    try {
        const product = await updateProduct(req.params.id, req.body);
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

module.exports = {all, one, create, update, destroy};