const router = require('express').Router();

const commentController = require('../controllers/commentController');
const validation = require('../middlewares/joiValidation');
const productSchemas = require('../schemas/productSchemas');

router.get('/:id', commentController.oneProduct);
router.post('/',validation(productSchemas.comment), commentController.create);
router.delete('/', commentController.destroy);
router.put('/',validation(productSchemas.comment), commentController.update);

module.exports = router;