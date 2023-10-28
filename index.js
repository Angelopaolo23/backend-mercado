require('dotenv').config();
const express = require('express');
const cors = require('cors');

const userRoutes = require('./src/routes/userRoutes');

const app = express();

app.use(cors());
app.use(express.json());
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`SERVIDOR ENCENDIDO EN PUERTO ${PORT}`);
});

app.get('/', (req, res) => {
    res.send('ArtMarket');
});

app.use('/users', userRoutes);

module.exports = app;