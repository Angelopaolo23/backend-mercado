const router = require("express").Router();

const cartController = require("../controllers/cartController");

router.get("", cartController.getAll);
router.get("/:id", cartController.oneCart);
router.post("", cartController.add);
router.put("/sustract", cartController.sustract);
router.delete("", cartController.removeOne);
router.delete("/:id", cartController.clearCartAfterCheckout);

module.exports = router;
