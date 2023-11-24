const Joi = require('joi');

const searchSchema = Joi.object({
    search: Joi.string()
    .max(100)
    .required(),
});

//HAY QUE REVISAR SI ESTE ESQUEMA CALZA CON EL INPUT QUE DEBO PASARLE A LA CONSULTA

module.exports = searchSchema;