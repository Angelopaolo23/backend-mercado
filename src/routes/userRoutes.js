const router = require ('express').Router();
const userController = require('../controllers/userController');


router.get('', userController.all);
router.get('/:id', userController.oneUser);
router.get('', userController.userLogued);

module.exports = router;