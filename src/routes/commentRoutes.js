const router = require('express').Router();

const commentController = require('../controllers/commentController');

router.get('/:id', commentController.oneProduct);
router.post('/', commentController.create);
router.delete('/', commentController.destroy);
router.put('/', commentController.update);

module.exports = router;