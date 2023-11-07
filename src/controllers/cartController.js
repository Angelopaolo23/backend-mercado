const {getProductByID, getCartInfo, addProduct, addOne, sustractOne, getCarts, addOneOrMore, deleteProducts} = require('../models/cart');

const getAll = async (req, res) => {
    try {
        const allCarts = await getCarts();
        res.json(allCarts);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
const oneCart = async (req, res) => {
    try {
        const products = await getCartInfo(req.params.id);
        res.status(200).json(products);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
const add = async (req, res) => {
    try {
        const product = await getProductByID(req.body);
        if (!product) {
            const newProduct = await addProduct(req.body);
            res.status(201).json(newProduct);
        } else {
            const addingProduct = await addOne(req.body);
            res.status(201).json(addingProduct);
        }   
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
const sustract = async (req, res) => {
    try {
        const product = await getProductByID(req.body);
        if (product) {
            const sustractingProduct = await sustractOne(req.body);
            deleteProducts(req.body.user_id);
            res.status(200).json(sustractingProduct);
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = {getAll, oneCart, add, sustract};