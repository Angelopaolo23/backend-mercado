const Joi = require('joi');

/*const validation = (schema) => {
    let joiValidation = (req, res, next) => {
        let { error } = schema.validate(req.body, {abortEarly: false});
        console.log(error);
    };
    return joiValidation;
};
*/
//module.exports = validation;

//const handler = (req, res, next);
const validation =  (schema, property) => {
    return (req, res, next) => {
        const { error } = schema.validate(req.body, {abortEarly: false});
        const valid = error == null;
        if (valid) {
            next();
        } else {
            const { details } = error;
            const message = details.map(i => i.message).join(',');
            console.log("error", message);
            res.status(422).json({error: message})
        }
    };
};

module.exports = validation;