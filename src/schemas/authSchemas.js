const Joi = require('joi');


const authSchemas = {
    register: Joi.object({
        username: Joi.string()
            .alphanum()
            .min(8)
            .max(25)
            .required(),

        password: Joi.string()
            .pattern(new RegExp('^[a-zA-Z0-9]{3,30}$'))
            .required(),

            confirmPassword: Joi.any()
            .equal(Joi.ref('password'))
            .required(),

        email: Joi.string()
            .email({ 
                minDomainSegments: 2, tlds: { allow: ['com', 'net', 'cl', 'es'] }, 
            })
            .required(),
    }),
    login: Joi.object({
        password: Joi.string()
            .pattern(new RegExp('^[a-zA-Z0-9]{3,30}$')),

        email: Joi.string()
            .email({ 
                minDomainSegments: 2, tlds: { allow: ['com', 'net', 'cl', 'es'] }, 
            }),
    }),
};

module.exports = authSchemas;