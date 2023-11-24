CREATE DATABASE artMarketplace;
\c artmarketplace


DROP TABLE IF EXISTS users;
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(25),
    email VARCHAR(255) UNIQUE,
    password VARCHAR(255)
);

DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    title VARCHAR (255),
    description TEXT,
    price INT,
    url_image VARCHAR(255),
    seller_id INT,
    FOREIGN KEY (seller_id) REFERENCES users(user_id)
);

DROP TABLE IF EXISTS verified_artists;
CREATE TABLE verified_artists (
    artist_id SERIAL PRIMARY KEY,
    username VARCHAR(25),
    description VARCHAR(255),
    role VARCHAR(25),
    artist_image VARCHAR(255),
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE shopping_cart (    
    user_id INT,
    product_id INT,
    price INT,
    quantity INT DEFAULT 1,
    paid boolean DEFAULT false,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO shopping_cart (user_id, product_id, price, quantity) VALUES
(2, 1, 9900, 3),
(1, 3, 5700, 2),
(2, 2, 8000, 4),
(1, 1, 9900, 1),
(3, 1, 9900, 2),
(2, 4, 11900, 4);


DROP TABLE IF EXISTS favorites;
CREATE TABLE favorites (
    favorite_id SERIAL PRIMARY KEY,
    user_id INT CHECK (user_id >= 0),
    product_id INT CHECK (product_id >= 0),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE
);


DROP TABLE IF EXISTS products_categories;
CREATE TABLE products_categories (
    product_id INT,
    category_id INT,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);


CREATE TABLE comments (
    comment_id serial PRIMARY KEY,
    user_id INT,
    product_id INT,
    content VARCHAR(150),
    comment_date TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

CREATE TABLE product_rating (
    rating_id serial PRIMARY KEY,
    user_id INT,
    product_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    rating_date TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);


INSERT INTO comments (user_id, product_id, content) VALUES  (3, 6, 'que linda fotografia');
INSERT INTO comments (user_id, product_id, content) VALUES  (8, 3, 'bonito atardecer');
INSERT INTO comments (user_id, product_id, content) VALUES  (11, 4, 'comentario sin imaginacion');
INSERT INTO comments (user_id, product_id, content) VALUES  (2, 3, 'no me gusta del todo');
INSERT INTO comments (user_id, product_id, content) VALUES  (6, 3, 'muy barato por la calidad de la foto');




INSERT INTO users (username, email, password) VALUES
('Ansel Adams', 'anseladams@example.com', 'AnselAdams1'),
('Dorothea Lange', 'dorothealange@example.com', 'DorotheaLange1'),
('Steve McCurry', 'stevemcCurry@example.com', 'SteveMcCurry1'),
('Annie Leibovitz', 'annieleibovitz@example.com', 'AnnieLeibovitz1'),
('Sebastião Salgado', 'sebastiãosalgado@example.com', 'SebastiãoSalgado1'),
('Henri Cartier-Bresson', 'henricartier-bresson@example.com', 'HenriCartier-Bresson1'),
('Cindy Sherman', 'cindysherman@example.com', 'CindySherman1'),
('Helmut Newton', 'helmutnewton@example.com', 'HelmutNewton1'),
('AlejandroLopez', 'alejandrolopez@example.com', 'AlejandroLopez1'),
('ChloeMartinez', 'chloemartinez@example.com', 'ChloeMartinez1'),
('ManuelGutierrez', 'manuelgutierrez@example.com', 'ManuelGutierrez1'),
('SophiaLee', 'sophialee@example.com', 'SophiaLee1'),
('DiegoHernandez', 'diegohernandez@example.com', 'DiegoHernandez1'),
('EmmaTaylor', 'emmataylor@example.com', 'EmmaTaylor1'),
('MiguelFernandez', 'miguelfernandez@example.com', 'MiguelFernandez1'),
('AvaRodriguez', 'avarodriguez@example.com', 'AvaRodriguez1'),
('GabrielGomez', 'gabrielgomez@example.com', 'GabrielGomez1'),
('IsabellaScott', 'isabellascott@example.com', 'IsabellaScott1'),
('RicardoRivera', 'ricardorivera@example.com', 'RicardoRivera1'),
('MiaMitchell', 'miamitchell@example.com', 'MiaMitchell1'),
('JoseSilva', 'josesilva@example.com', 'JoseSilva1'),
('AmeliaTurner', 'ameliaturner@example.com', 'AmeliaTurner1'),
('SamuelOrtega', 'samuelortega@example.com', 'SamuelOrtega1'),
('VictoriaWard', 'victoriaward@example.com', 'VictoriaWard1'),
('LucasCastillo', 'lucascastillo@example.com', 'LucasCastillo1'),
('LilyRamirez', 'lilyramirez@example.com', 'LilyRamirez1'),
('MatiasLopez', 'matiaslopez@example.com', 'MatiasLopez1'),
('HarperNguyen', 'harpernguyen@example.com', 'HarperNguyen1'),
('SofiaMartinez', 'sofiamartinez@example.com', 'SofiaMartinez1'),
('BenjaminKim', 'benjaminkim@example.com', 'BenjaminKim1'),
('EmilyHernandez', 'emilyhernandez@example.com', 'EmilyHernandez1');

INSERT INTO products (title, description, price, url_image, seller_id) VALUES
('Colorful Abstract', 'Vibrant and expressive abstract painting with a mix of colors.', 350, 'https://images.unsplash.com/photo-1682685795463-0674c065f315?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1326&q=80', 8),
('Natures Beauty', 'A stunning photograph capturing the beauty of nature.', 150, 'https://plus.unsplash.com/premium_photo-1688431299086-bf835ca28a9d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 4),
('Portrait of Grace', 'An exquisite portrait of a graceful woman.', 500, 'https://images.unsplash.com/photo-1689344682959-d8b85fdab21a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 6),
('Urban Exploration', 'A captivating photograph showcasing the beauty of urban architecture.', 200, 'https://images.unsplash.com/photo-1688503677973-0c68fcc15175?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=930&q=80', 7),
('The Starry Night', 'A mesmerizing painting depicting a starry night sky.', 800, 'https://images.unsplash.com/photo-1687360440155-81bdb9ecd713?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=870&q=80', 1),
('Surreal Dreams', 'A surreal and dreamlike illustration.', 300, 'https://images.unsplash.com/photo-1688658108841-89577bba566a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80', 3),
('Wildlife Majesty', 'A powerful photograph capturing the majesty of wildlife.', 180, 'https://images.unsplash.com/photo-1689163928284-ccd49ac5248a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 5),
('Abstract Thoughts', 'An abstract artwork that sparks contemplation.', 250, 'https://plus.unsplash.com/premium_photo-1678329516034-8fe848659874?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80', 2),
('Landscapes of Serenity', 'A collection of serene landscape paintings.', 450, 'https://plus.unsplash.com/premium_photo-1689177357515-61040a71d890?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 3),
('The Enchanted Forest', 'A magical painting of an enchanted forest.', 380, 'https://images.unsplash.com/photo-1689363199550-d0f417ed21db?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 1),
('City Lights', 'A breathtaking photograph capturing the beauty of city lights at night.', 170, 'https://images.unsplash.com/photo-1688048110668-f07715ee9156?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=733&q=80', 8),
('Expressions of Joy', 'A heartwarming painting depicting expressions of joy.', 320, 'https://images.unsplash.com/photo-1689284255307-04257bb8df0d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 2),
('Ethereal Waters', 'An ethereal and tranquil painting of a waterfront.', 410, 'https://images.unsplash.com/photo-1687360440648-ec9708d52086?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1276&q=80', 6),
('The Lost Horizon', 'An evocative artwork illustrating a distant and mysterious horizon.', 290, 'https://images.unsplash.com/photo-1689595131476-e141af904891?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 7),
('Dance of Fire', 'A fiery and passionate depiction of dance.', 270, 'https://images.unsplash.com/photo-1689308271349-e685f6ec405a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1828&q=80', 4),
('Memories Captured', 'A collection of photographs capturing timeless memories.', 180, 'https://images.unsplash.com/photo-1688917169732-834612d59842?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=688&q=80', 5),
('Whimsical World', 'A whimsical and imaginative artwork.', 330, 'https://images.unsplash.com/photo-1689236913171-2f53681b8e82?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1374&q=80', 2),
('Majestic Mountains', 'A majestic painting showcasing the grandeur of mountains.', 480, 'https://images.unsplash.com/photo-1682687982502-b05f0565753a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 5),
('Rays of Hope', 'A hopeful artwork with rays of light shining through the clouds.', 250, 'https://images.unsplash.com/photo-1689198163476-d80775a6e853?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 8),
('The Dancers Elegance', 'An elegant portrayal of a dancer in motion.', 320, 'https://images.unsplash.com/photo-1688927036300-3c38b1e9cc01?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 7),
('Ancient Wonders', 'A depiction of ancient wonders of the world.', 390, 'https://images.unsplash.com/photo-1689126437563-f5d936a06713?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 3),
('Abstract Fusion', 'A fusion of abstract shapes and colors.', 280, 'https://plus.unsplash.com/premium_photo-1687411984360-9560bc31048f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80', 6),
('The Symphony', 'An artistic representation of a symphony performance.', 210, 'https://images.unsplash.com/photo-1688671141922-a84498755e03?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 1),
('Graceful Swans', 'A serene painting depicting graceful swans on a lake.', 370, 'https://images.unsplash.com/photo-1688903550207-392083c9a5a3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 2),
('Dreams of Flight', 'A dreamy artwork portraying fantasies of flight.', 190, 'https://images.unsplash.com/photo-1688765938953-a5a7cc205b0c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=688&q=80', 7),
('The Ancient Forest', 'A mystical painting capturing the enchantment of an ancient forest.', 490, 'https://images.unsplash.com/photo-1688725755373-10d1bb23b55d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80', 4);

INSERT INTO verified_artists (username, description, role, artist_image, user_id) VALUES
('Ansel Adams', 'Conocido por sus impresionantes fotografías de paisajes y su trabajo en el Parque Nacional de Yosemite.', 'artista', 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 1),
('Dorothea Lange', 'Documentalista y fotoperiodista famosa por sus fotografías durante la Gran Depresión de los Estados Unidos.', 'artista', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 2),
('Steve McCurry', 'Reconocido por su icónica fotografía "La niña afgana" y su extenso trabajo en fotoperiodismo.', 'artista', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 3),
('Annie Leibovitz', 'Renombrada fotógrafa de retratos y colaboradora de la revista Vanity Fair y Rolling Stone.', 'artista', 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 4),
('Sebastião Salgado', 'Fotógrafo documentalista brasileño famoso por sus proyectos sobre temas sociales y medioambientales.', 'artista', 'https://images.unsplash.com/photo-1522556189639-b150ed9c4330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80', 5),
('Henri Cartier-Bresson', 'Considerado el padre del fotoperiodismo moderno y fundador de la agencia Magnum Photos.', 'artista', 'https://images.unsplash.com/photo-1522529599102-193c0d76b5b6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80', 6),
('Cindy Sherman', 'Conocida por sus autorretratos artísticos y su exploración de la identidad y la representación.', 'artista', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=764&q=80', 7),
('Helmut Newton', 'Fotógrafo de moda y retratos conocido por su estilo provocativo y glamuroso.', 'artista', 'https://images.unsplash.com/photo-1521119989659-a83eee488004?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=723&q=80', 8);


INSERT INTO categories (name) VALUES ('Ilustraciones');
INSERT INTO categories (name) VALUES ('Fotografías');
INSERT INTO categories (name) VALUES ('Fanzines');
INSERT INTO categories (name) VALUES ('Escritos');
INSERT INTO categories (name) VALUES ('Collages');
INSERT INTO categories (name) VALUES ('Pinturas');

INSERT INTO products_categories (product_id, category_id) VALUES (1, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (2, 4);
INSERT INTO products_categories (product_id, category_id) VALUES (5, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (8, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (16, 2);

-- Buscar productos en la categoría "Fotografias"
SELECT p.*
FROM products p
JOIN products_categories pc ON p.product_id = pc.product_id
WHERE pc.category_id = 3;