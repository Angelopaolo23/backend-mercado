const router = require("express").Router();

const productController = require("../controllers/productController");
const validation = require("../middlewares/joiValidation");
const productSchemas = require("../schemas/productSchemas");

router.get("", productController.all);
router.get("/:category", productController.productsByCategories);
router.get("/:id", productController.one);
router.post("", validation(productSchemas.product), productController.create);
router.put("/:id", validation(productSchemas.update), productController.update);
router.delete("/:id", productController.destroy);
router.post(
  "/rating",
  validation(productSchemas.rating),
  productController.rating
);

module.exports = router;
