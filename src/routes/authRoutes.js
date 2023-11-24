const router = require('express').Router();
const authController = require('../controllers/authController');
const validation = require('../middlewares/joiValidation');

const authSchemas = require('../schemas/authSchemas');

router.post('/register', validation(authSchemas.register), authController.register);
router.post('/login', validation(authSchemas.login), authController.login);

module.exports = router;
