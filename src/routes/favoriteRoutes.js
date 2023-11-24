const router = require('express').Router();

const favoritesController = require('../controllers/favoriteController');

router.get('/:id', favoritesController.all);
router.post('/:id', favoritesController.create);
router.delete('/:id', favoritesController.destroy);

module.exports = router;