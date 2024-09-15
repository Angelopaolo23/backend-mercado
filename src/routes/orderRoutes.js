const router = require("express").Router();

const ordersController = require("../controllers/ordersController");

router.get("/:id", ordersController.getAll);
router.post("/:id", ordersController.add);

module.exports = router;
