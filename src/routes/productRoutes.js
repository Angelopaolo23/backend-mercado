const router = require('express').Router();

const productController = require('../controllers/productController');

router.get('', productController.all);
router.get('/:id', productController.one);
router.post('', productController.create);
router.put('/:id', productController.update);
router.delete('/:id', productController.destroy);

module.exports = router;