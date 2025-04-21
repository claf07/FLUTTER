const express=require('express');
const { getProduct, getProducts, createProducts, updateProduct, DeleteProduct } = require('../controllers/products.controllers');
const router=express.Router();//with router we are going to define the routes

router.get('/',getProducts);
router.get('/:id',getProduct);
router.post('/',createProducts);
router.put('/:id',updateProduct);
router.delete('/:id',DeleteProduct);

module.exports = router;