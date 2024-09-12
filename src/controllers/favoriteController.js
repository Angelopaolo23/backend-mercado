const {
  getFavorites,
  newFavorite,
  deleteFavorite,
  getFavoriteById,
} = require("../models/favorites");

const all = async (req, res) => {
  try {
    const favorites = await getFavorites(req.params.id);
    res.status(200).json(favorites);
  } catch (error) {
    console.error("Error al obtener favoritos:", error);
    res.status(500).json({ error: error.message });
  }
};
const create = async (req, res) => {
  try {
    const existingFavorite = await getFavoriteById(
      req.params.user_id,
      req.body.product_id
    );
    if (existingFavorite) {
      return res
        .status(409)
        .json({ error: "Ya existe un favorito con este ID" });
    }
    const favorite = await newFavorite(req.body.product_id, req.params.id);
    res.status(201).json(favorite);
  } catch (error) {
    console.error("Error al crear un favorito:", error);
    res.status(500).json({ error: error.message });
  }
};
const destroy = async (req, res) => {
  try {
    const existingFavorite = await getFavoriteById(
      req.params.user_id,
      req.body.product_id
    );
    if (existingFavorite) {
      const favorite = await deleteFavorite(req.body.product_id, req.params.id);
      res.status(200).json(favorite);
    }
  } catch (error) {
    console.error("Error al remover la obra de favoritos:", error);
    res.status(500).json({ error: error.message });
  }
};
module.exports = { all, create, destroy };
