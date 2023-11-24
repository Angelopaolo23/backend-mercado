const { getFavorites, newFavorite, deleteFavorite } = require('../models/favorites');

//DUDO QUE OBTENER EL ID DEL USUARIO POR EL REQ PARAMS ESTE BIEN, YO CREO QUE EL USER_ID DEBE ESTAR DISPONIBILIZADO EN EL CONTEXT EN REACT Y OBTENERLO DE ESA FORMA
const all = async (req, res) => {
    try {
        const favorites = await getFavorites(req.params.id);
        res.json(favorites);
    } catch(error) {
        res.status(500).json({ error: error.message });
    }
};
const create = async (req, res) => {
    try {
        const favorite = await newFavorite(req.body.product_id, req.params.id);
        res.json(favorite);        
    } catch (error) {
        res.status(500).json({error: error.message});
    }
};
const destroy = async (req, res) => {
    try {
        const favorite = await deleteFavorite(req.body.product_id, req.params.id);
        res.json(favorite);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
module.exports = {all, create, destroy};