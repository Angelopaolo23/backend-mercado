const Joi = require('joi');


const productSchemas = {
    product : Joi.object({
        title: Joi.string()
            .max(255)
            .required(),
        
        description: Joi.string()
            .required(),
        
        price: Joi.number()
            .integer()
            .positive()
            .required(),
        
        url_image: Joi.string()
            .uri()
            .max(255)
            .required(),
        
        seller_id: Joi.number()
            .integer()
            .positive()
            .required(),
        //MAX 6 YA QUE HAY 6 CATEGORIAS DE PRODUCTOS ACTUALMENTE
        category: Joi.number()
            .integer()
            .positive()
            .max(6)
            .required(),
    }),
    update : Joi.object({
        title: Joi.string()
            .max(255)
            .required(),
        
        description: Joi.string()
            .required(),
        
        price: Joi.number()
            .integer()
            .positive()
            .required(),
        
        url_image: Joi.string()
            .uri()
            .max(255)
            .required(),
        
        //MAX 6 YA QUE HAY 6 CATEGORIAS DE PRODUCTOS ACTUALMENTE
        category: Joi.number()
            .integer()
            .positive()
            .max(6)
            .required(),
    }),
    rating : Joi.object({
        user_id: Joi.number()
            .integer()
            .positive()
            .required(),
        
        product_id: Joi.number()
            .integer()
            .positive()
            .required(),
        
        rating: Joi.number()
            .integer()
            .min(1)
            .max(5)
            .required(),
    }),
    //ESTOY INCLUYENDO LA CATEGORIA AL CREAR EL PRODUCTO DIRECTAMENTE EN SCHEMA product
    /*category : Joi.object({
        product_id: Joi.number()
            .integer()
            .positive()
            .required(),
        category_id: Joi.number()
            .integer()
            .positive()
            .required()
    }),*/
    comment : Joi.object({
        user_id: Joi.number()
            .integer()
            .positive()
            .required(),
        
        product_id: Joi.number()
            .integer()
            .positive()
            .required(),
        
        content: Joi.string()
        .max(150)    
        .required()
    }),
};

module.exports = productSchemas;