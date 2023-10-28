const { getUsers, getUserByID, getUserByUsername, getUserByEmail } = require('../models/users');

const all = async (req, res) => {
    try {
        const artists = await getUsers();
        res.status(200).json(artists);
    } catch (error) {
        res.status(500).json({error: error.message});
    }
};

const userLogued = async (req, res) => {
    try {
        const loguedUserData = await getUserByEmail(req.email);
        res.status(200).json(loguedUserData);
    } catch (error) {
        res.status(500).json({error: error.message});
    }
};

const oneUser = async (req, res) => {
    try {
        const user = await getUserByID(req.params.id);
        res.status(200).json(user);
    } catch (error) {
        res.status(500).json({error: error.message});
    }
};

//NO HE USADO EL getUserByUsername
module.exports = { all, userLogued, oneUser };