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
    const { username, email, password: originalPassword } = req.body;
    const existingUser = await getUserByEmail(email);
    if (existingUser) {
      return res
        .status(409)
        .json({ error: "Ya existe una cuenta con este email" });
    }
    const hashedPassword = await bcrypt.hash(originalPassword, 10);
    const user = await createUser(username, email, hashedPassword);
    if (!user) {
      throw new Error("No se pudo crear el usuario");
    }
    const token = jwt.sign(
      { email: user.email, userId: user.user_id },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN }
    );
    const { password: _, email: _, ...userWithoutPasswordAndEmail } = user;
    res.status(201).json({ token, user: userWithoutPasswordAndEmail });
  } catch (error) {
    console.error("Error en el registro:", error);
    res.status(500).json({ error: "Error en el registro de usuario" });
  }
};
const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await getUserByEmail(email);
    if (!user) {
      return res.status(401).json({ error: "Credenciales inválidas" });
    }
    const hashedPassword = user.password;
    const match = await bcrypt.compare(password, hashedPassword);
    if (!match) {
      return res.status(401).json({ error: "Credenciales inválidas" });
    }
    const token = jwt.sign(
      { email: user.email, userId: user.user_id },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN }
    );
    const { password: _, email: _, ...userWithoutPasswordAndEmail } = user;
    res.status(200).json({ token, user: userWithoutPasswordAndEmail });
  } catch (error) {
    console.error("Error en el login:", error);
    res.status(500).json({ error: "Error en el proceso de inicio de sesión" });
  }
};

module.exports = { register, login };
