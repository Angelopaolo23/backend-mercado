require('dotenv').config();
const express = require('express');
const cors = require('cors');

const userRoutes = require('./src/routes/userRoutes');
const productRoutes = require('./src/routes/productRoutes');
const authRoutes = require('./src/routes/authRoutes');
const cartRoutes = require('./src/routes/cartRoutes');
const commentRoutes = require('./src/routes/commentRoutes');
const favoriteRoutes = require('./src/routes/favoriteRoutes');
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
app.use('/artworks', productRoutes);
app.use('/auth', authRoutes);
app.use('/cart', cartRoutes);
app.use('/comments', commentRoutes);
app.use('/favorites', favoriteRoutes);

module.exports = app;