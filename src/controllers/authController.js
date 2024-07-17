const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const {
  getUserByEmail,
  createUser,
  updateUser,
  deleteUser,
} = require("../models/users");

const register = async (req, res) => {
  try {
    const originalPassword = req.body.password;
    const hashedPassword = await bcrypt.hash(originalPassword, 10);
    req.body.password = hashedPassword;
    if (await getUserByEmail(req.body.email)) {
      return res
        .status(400)
        .json({ error: "Ya existe una cuenta con este email" });
    } else {
      const user = await createUser(req.body);
      if (!user) {
        throw new Error("No se pudo crear el usuario");
      }
      //RESPUESTA PARA DESPLEGAR NOMBRE DE USUARIO?
      res.status(201).json(user);
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await getUserByEmail(email);
    if (!user) {
      return res.status(400).json({ error: "Usuario no encontrado" });
    }
    const hashedPassword = user.password;
    const match = await bcrypt.compare(password, hashedPassword);

    if (match) {
      const token = jwt.sign(
        { email: user.email, user_id: user.user_id },
        process.env.JWT_SECRET
      );
      //ES NECESARIA UNA RESPUESTA PARA DESPLEGAR EL NOMBRE DEL USUARIO?
      res.status(200).json(token);
    } else {
      return res
        .status(400)
        .json({ error: "Usuario o contraseña incorrectas" });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = { register, login };
