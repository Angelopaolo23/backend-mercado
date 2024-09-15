CREATE DATABASE artMarketplace;
\c artmarketplace

DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(30) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password TEXT NOT NULL,
    photo TEXT DEFAULT 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT check_photo_url CHECK (photo IS NULL OR photo ~ '^https?://')
);

DROP TABLE IF EXISTS products CASCADE;
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price INT NOT NULL CHECK (price >= 0),
    url_image TEXT NOT NULL,
    seller_id INT NOT NULL,
    format VARCHAR(255),
    available BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (seller_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT check_url_image CHECK (url_image ~ '^https?://')
);
ALTER TABLE products
ADD COLUMN inspiration VARCHAR(255),
ADD COLUMN materials VARCHAR(100);

DROP TABLE IF EXISTS verified_artists CASCADE;
CREATE TABLE verified_artists (
    artist_id SERIAL PRIMARY KEY,
    username VARCHAR(30) NOT NULL UNIQUE,
    description TEXT,
    role VARCHAR(50),
    artist_image TEXT,
    user_id INT NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS shopping_cart CASCADE;
CREATE TABLE shopping_cart (
    user_id INT,
    product_id INT,
    price INT NOT NULL CHECK (price >= 0),
    quantity INT DEFAULT 1,
    paid BOOLEAN DEFAULT false,
    added_date TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS orders CASCADE;
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    order_date TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT
);


DROP TABLE IF EXISTS order_items CASCADE;
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price INT NOT NULL CHECK (price >= 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT
);



DROP TABLE IF EXISTS favorites CASCADE;
CREATE TABLE favorites (
    user_id INT,
    product_id INT,
    favorite_date TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS categories CASCADE;
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

DROP TABLE IF EXISTS products_categories CASCADE;
CREATE TABLE products_categories (
    product_id INT,
    category_id INT,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS comments CASCADE;
CREATE TABLE comments (
    comment_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    content TEXT NOT NULL,
    comment_date TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS product_rating CASCADE;
CREATE TABLE product_rating (
    user_id INT,
    product_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    rating_date TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

PRODUCTOS DE CATEGORIA ILUSTRACIONES

INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Sueño en Acuarela', 'Ilustración onírica que captura la esencia de los sueños con suaves tonos pastel y formas etéreas.', 45000, 'https://images.pexels.com/photos/11592813/pexels-photo-11592813.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 3, '40 x 30 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Geometría Urbana', 'Ilustración que explora la intersección entre las formas geométricas y el paisaje urbano moderno.', 62000, 'https://images.pexels.com/photos/11643390/pexels-photo-11643390.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 7, '50 x 50 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Naturaleza Abstracta', 'Una interpretación vibrante y abstracta de elementos naturales, fusionando color y forma.', 38000, 'https://images.pexels.com/photos/5011647/pexels-photo-5011647.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 12, '35 x 45 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Retrato Minimalista', 'Ilustración que captura la esencia de un rostro con líneas simples y elegantes.', 29000, 'https://images.pexels.com/photos/11592804/pexels-photo-11592804.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 3, '25 x 35 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Cosmos en Tinta', 'Una exploración detallada del universo y sus maravillas, realizada enteramente en tinta negra.', 75000, 'https://images.pexels.com/photos/10377281/pexels-photo-10377281.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 22, '60 x 80 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Fragmentos de Emoción', 'Serie de ilustraciones que capturan diferentes estados emocionales a través de formas abstractas y colores vibrantes.', 58000, 'https://images.pexels.com/photos/10643964/pexels-photo-10643964.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 15, '40 x 60 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Simetría Botánica', 'Delicada ilustración de plantas y flores que explora la belleza de la simetría en la naturaleza.', 42000, 'https://images.pexels.com/photos/8832898/pexels-photo-8832898.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 9, '30 x 40 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Ciudades Oníricas', 'Ilustración surrealista que fusiona elementos arquitectónicos de diferentes épocas en un paisaje urbano fantástico.', 69000, 'https://images.pexels.com/photos/10996844/pexels-photo-10996844.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 28, '50 x 70 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Metamorfosis', 'Secuencia de ilustraciones que muestran la transformación gradual de una forma a otra, simbolizando el cambio y el crecimiento.', 55000, 'https://images.pexels.com/photos/10996827/pexels-photo-10996827.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 5, '45 x 60 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Constelaciones Personales', 'Ilustración que combina elementos de la astrología y el autorretrato para crear un mapa estelar único y personal.', 47000, 'https://images.pexels.com/photos/14032494/pexels-photo-14032494.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 19, '40 x 40 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Laberinto de Memorias', 'Ilustración intrincada que representa un laberinto lleno de símbolos y objetos evocadores de recuerdos personales.', 72000, 'https://plus.unsplash.com/premium_photo-1667238530487-802e1b175506?q=80&w=1579&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 11, '60 x 80 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Danza de las Sombras', 'Serie de ilustraciones que juegan con la luz y la sombra para crear figuras dinámicas y misteriosas.', 51000, 'https://images.unsplash.com/photo-1579762714453-51d9913984e2?q=80&w=1462&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 24, '35 x 50 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Cartografía Imaginaria', 'Mapa detallado de un mundo fantástico, combinando elementos de cartografía tradicional con ilustraciones whimsical.', 79000, 'https://images.unsplash.com/photo-1579762715459-5a068c289fda?q=80&w=1588&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 7, '70 x 100 cm');

INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Microcosmos', 'Ilustración detallada que explora un mundo microscópico imaginario, lleno de criaturas y estructuras fantásticas.', 66000, 'https://plus.unsplash.com/premium_photo-1682125139523-92d7def89cd1?q=80&w=1480&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 13, '50 x 50 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Sinfonía de Colores', 'Abstracta ilustración que traduce una pieza musical en una explosión de formas y colores.', 54000, 'https://images.unsplash.com/photo-1584448097639-99cf648e8def?q=80&w=1510&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 22, '45 x 65 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Jardín de los Sueños', 'Ilustración onírica de un jardín surrealista donde las plantas cobran vida y adoptan formas imposibles.', 61000, 'https://images.unsplash.com/photo-1584448033614-882b971a36f3?q=80&w=1516&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 17, '55 x 75 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Caleidoscopio Urbano', 'Representación caleidoscópica de la vida urbana, fusionando elementos arquitectónicos en un patrón hipnótico.', 57000, 'https://images.unsplash.com/photo-1584448062058-0d13ba997eb0?q=80&w=1510&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 9, '40 x 60 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Retratos del Tiempo', 'Serie de ilustraciones que capturan el paso del tiempo en un solo rostro, desde la infancia hasta la vejez.', 73000, 'https://images.unsplash.com/photo-1584448097764-374f81551427?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 26, '50 x 70 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Bestiario Moderno', 'Colección de ilustraciones que reimaginan animales comunes con un toque surrealista y contemporáneo.', 68000, 'https://images.unsplash.com/photo-1584446922442-7ac6b8c118f3?q=80&w=1512&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 4, '45 x 60 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Topografía Emocional', 'Mapa abstracto que representa el paisaje interno de las emociones humanas a través de colores y formas.', 59000, 'https://images.unsplash.com/photo-1582201942988-13e60e4556ee?q=80&w=1602&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 20, '50 x 65 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Fractales Orgánicos', 'Ilustración que explora la belleza de los patrones fractales encontrados en la naturaleza, desde helechos hasta cristales de hielo.', 64000, 'https://images.unsplash.com/photo-1584446922448-efd3351dad71?q=80&w=1614&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 15, '40 x 55 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Mecánica de los Sueños', 'Ilustración steampunk que representa una máquina imaginaria capaz de capturar y visualizar los sueños.', 76000, 'https://images.unsplash.com/photo-1577086677645-1e5e43894316?q=80&w=1599&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 28, '60 x 80 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Arquitectura Imposible', 'Serie de ilustraciones que desafían las leyes de la física con estructuras arquitectónicas imaginarias e imposibles.', 71000, 'https://plus.unsplash.com/premium_photo-1681400184787-58e368e93fd7?q=80&w=1548&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 11, '55 x 75 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Mitología Personal', 'Ilustración que crea un panteón de deidades y criaturas míticas inspiradas en experiencias y sueños personales del artista.', 67000, 'https://images.unsplash.com/photo-1583324622624-3c34dc79b153?q=80&w=1548&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 7, '50 x 70 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Sinestesia Visual', 'Colección de ilustraciones que intentan representar visualmente diferentes sonidos y músicas, explorando la sinestesia.', 63000, 'https://plus.unsplash.com/premium_photo-1682125159925-f8abacde80dd?q=80&w=1596&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 24, '45 x 60 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Cartografía del Alma', 'Mapa ilustrado del interior de un ser humano, representando emociones, memorias y sueños como territorios y landmarks.', 78000, 'https://plus.unsplash.com/premium_photo-1682308354667-53cdfe770c5c?q=80&w=1708&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 13, '65 x 90 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Ecosistemas Imaginarios', 'Serie de ilustraciones detalladas que presentan ecosistemas fantásticos con flora y fauna inventada.', 70000, 'https://images.unsplash.com/photo-1580713864169-f7f52047cde6?q=80&w=1560&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 19, '55 x 75 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Tipografía Viviente', 'Ilustración que transforma letras y palabras en criaturas y paisajes vivos, jugando con la forma y el significado.', 56000, 'https://images.unsplash.com/photo-1580130732478-4e339fb6836f?q=80&w=1498&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 22, '45 x 60 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Máquina del Tiempo', 'Ilustración detallada de un dispositivo fantástico capaz de viajar a través del tiempo, mezclando elementos steampunk y futuristas.', 74000, 'https://images.unsplash.com/photo-1580130544346-77d05d03d742?q=80&w=1560&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 9, '50 x 70 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Sueños en Papel', 'Collage ilustrado que combina elementos dibujados a mano con recortes de papel, creando un paisaje onírico y texturizado.', 52000, 'https://images.unsplash.com/photo-1580130718810-358e5e8af61b?q=80&w=1494&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 17, '40 x 55 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Metamorfosis Urbana', 'Serie de ilustraciones que muestran la transformación de una ciudad a lo largo del tiempo, desde sus orígenes hasta un futuro imaginario.', 69000, 'https://images.unsplash.com/photo-1584446952473-43402d58f026?q=80&w=1449&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 28, '60 x 80 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Anatomía de lo Invisible', 'Ilustración científica imaginaria que explora la estructura interna de conceptos abstractos como el amor, el tiempo o la creatividad.', 77000, 'https://images.unsplash.com/photo-1575479114409-af5f55e5fc39?q=80&w=1606&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 5, '55 x 75 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Paisajes Neuronales', 'Ilustración que representa el cerebro humano como un vasto paisaje, con ideas y recuerdos como elementos geográficos.', 65000, 'https://plus.unsplash.com/premium_photo-1682124721097-156a331a6f5d?q=80&w=1612&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 13, '50 x 65 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Alfabeto Cósmico', 'Serie de 26 ilustraciones, cada una representando una letra del alfabeto inspirada en elementos cósmicos y astronómicos.', 80000, 'https://images.unsplash.com/photo-1535083252457-6080fe29be45?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 24, '70 x 100 cm');


PRODUCTOS DE CATEGORIA FOTOGRAFIAS

INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Esencia del Invierno', 'Fotografía en blanco y negro que captura la quietud y belleza de un paisaje nevado.', 42000, 'https://images.unsplash.com/photo-1542887800-faca0261c9e1?q=80&w=1454&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 2, '40 x 60 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Reflejos Urbanos', 'Imagen que captura la vida citadina reflejada en los charcos después de la lluvia.', 38000, 'https://images.unsplash.com/photo-1522069169874-c58ec4b76be5?q=80&w=1612&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 6, '30 x 45 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Geometría Natural', 'Fotografía macro de una hoja que resalta las intrincadas estructuras y patrones de la naturaleza.', 29000, 'https://images.unsplash.com/photo-1610911896465-e6da31a608d0?q=80&w=1664&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 10, '20 x 30 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Abstracción Líquida', 'Captura artística de líquidos en movimiento, creando formas y colores fascinantes.', 55000, 'https://images.unsplash.com/photo-1604094075229-fc4103fbacf7?q=80&w=1635&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 14, '50 x 70 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Alma de la Ciudad', 'Fotografía nocturna que captura la energía y el movimiento de una ciudad bulliciosa.', 48000, 'https://images.unsplash.com/photo-1529040274442-815019b0e4fc?q=80&w=1586&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 18, '40 x 60 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Danza de Colores', 'Explosión de colores capturada en alta velocidad, creando patrones abstractos y vibrantes.', 63000, 'https://images.unsplash.com/photo-1719141117097-ff388b044a80?q=80&w=1826&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 22, '60 x 90 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Simetría Perfecta', 'Fotografía arquitectónica que destaca la belleza geométrica de un edificio moderno.', 51000, 'https://images.unsplash.com/photo-1719141116042-cb4103af0668?q=80&w=1826&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 26, '45 x 65 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Susurros del Océano', 'Imagen serena de una playa al amanecer, capturando la calma y la belleza del mar.', 39000, 'https://images.unsplash.com/photo-1677759650344-4fe4ed9e9598?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 30, '35 x 50 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Texturas Olvidadas', 'Detalle de una pared antigua, revelando patrones y texturas fascinantes creadas por el tiempo.', 33000, 'https://images.unsplash.com/photo-1666757490538-d5eb58643132?q=80&w=1589&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 2, '25 x 35 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Instante Congelado', 'Fotografía de alta velocidad que captura el momento exacto de una gota de agua impactando.', 58000, 'https://images.unsplash.com/photo-1600554023121-cd7aec335041?q=80&w=1588&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 6, '50 x 75 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Perspectiva Única', 'Vista aérea de un paisaje urbano que revela patrones y estructuras invisibles desde el suelo.', 72000, 'https://images.unsplash.com/photo-1616617961953-9ffb00613644?q=80&w=1664&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 10, '70 x 100 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Danza de la Luz', 'Fotografía abstracta que captura el movimiento de luces en la noche, creando trazos de color.', 45000, 'https://images.unsplash.com/photo-1518791127-f4055930e461?q=80&w=1597&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 14, '40 x 55 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Espejo del Alma', 'Retrato en blanco y negro que captura la profundidad y emoción en los ojos del sujeto.', 61000, 'https://images.unsplash.com/photo-1559793978-37ab7dd23777?q=80&w=1617&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 18, '50 x 70 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Geometría Urbana', 'Composición minimalista que resalta las líneas y ángulos de la arquitectura moderna.', 49000, 'https://images.unsplash.com/photo-1632159336539-21104caef467?q=80&w=1588&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 22, '45 x 60 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Sombras Elocuentes', 'Fotografía que juega con las sombras para crear una narrativa visual intrigante.', 36000, 'https://images.unsplash.com/photo-1632159335392-76d387e58e86?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 26, '30 x 40 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Retrato de la Naturaleza', 'Macro fotografía que revela los detalles intrincados de una flor exótica.', 43000, 'https://plus.unsplash.com/premium_photo-1669810170082-82c74db4e09b?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 30, '35 x 50 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Horizontes Infinitos', 'Paisaje panorámico que captura la vastedad y belleza de un desierto al atardecer.', 68000, 'https://images.unsplash.com/photo-1666757531731-b361614b1871?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 2, '80 x 120 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Reflejos del Pasado', 'Fotografía nostálgica de un antiguo automóvil reflejado en un charco, evocando una era pasada.', 52000, 'https://images.unsplash.com/photo-1604763831872-e63aa85fcaab?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 6, '45 x 65 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Abstracción Natural', 'Detalle de minerales que crea una composición abstracta de colores y texturas.', 41000, 'https://images.unsplash.com/photo-1723164469880-7d52e24b590c?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 10, '35 x 50 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Sinfonía de Colores', 'Fotografía aérea de campos de tulipanes en flor, creando un mosaico vibrante de colores.', 75000, 'https://plus.unsplash.com/premium_photo-1673105873247-a4a7d4973e25?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 14, '70 x 100 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Texturas del Tiempo', 'Primer plano de la corteza de un árbol centenario, mostrando las marcas del paso del tiempo.', 37000, 'https://plus.unsplash.com/premium_photo-1664303371069-9ab642bdfa54?q=80&w=1746&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 18, '30 x 45 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Simetrías Naturales', 'Fotografía que explora la belleza simétrica de un insecto exótico.', 46000, 'https://images.unsplash.com/photo-1718734295805-3028c72a69d4?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 22, '40 x 55 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Serenidad Acuática', 'Captura subacuática que revela la tranquila belleza de un arrecife de coral.', 59000, 'https://images.unsplash.com/photo-1467991521834-fb8e202c7074?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 26, '50 x 75 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Danza Aérea', 'Fotografía de aves en vuelo, capturando la gracia y libertad del movimiento.', 53000, 'https://images.unsplash.com/photo-1517315003714-a071486bd9ea?q=80&w=1742&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 30, '45 x 65 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Horizontes Urbanos', 'Panorámica del perfil de una ciudad al atardecer, capturando la transición entre el día y la noche.', 71000, 'https://images.unsplash.com/photo-1517210122415-b0c70b2a09bf?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 2, '80 x 120 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Retrato de la Inocencia', 'Conmovedor retrato en blanco y negro de un niño, capturando la pureza de la infancia.', 57000, 'https://images.unsplash.com/photo-1561570541-aaba21a3ecf0?q=80&w=1760&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 6, '50 x 70 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Geometría Celestial', 'Fotografía nocturna que captura el movimiento de las estrellas en el cielo.', 66000, 'https://images.unsplash.com/photo-1503198515498-d0bd9ed16902?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 10, '60 x 90 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Texturas Industriales', 'Detalle de maquinaria industrial que revela patrones y texturas fascinantes.', 44000, 'https://images.unsplash.com/photo-1666757466247-96ca6330be80?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 14, '40 x 55 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Calma después de la Tormenta', 'Paisaje sereno capturado después de una tormenta, mostrando el contraste entre el cielo turbulento y la tierra tranquila.', 62000, 'https://images.unsplash.com/photo-1644193808979-8589bb7155c5?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 18, '55 x 80 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Fractales de Hielo', 'Macro fotografía de cristales de hielo, revelando patrones geométricos naturales.', 47000, 'https://images.unsplash.com/photo-1675117543541-012eb012f457?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 22, '35 x 50 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Energía en Movimiento', 'Captura de alta velocidad de una ola rompiendo, congelando la fuerza del océano en un instante.', 69000, 'https://images.unsplash.com/photo-1644193808957-a8ed34adcda3?q=80&w=3174&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 26, '60 x 90 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Sombras Elongadas', 'Fotografía minimalista que juega con las largas sombras proyectadas al atardecer.', 40000, 'https://images.unsplash.com/photo-1675117412156-ae1f37f82b05?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 30, '30 x 45 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Reflejos Urbanos', 'Imagen que captura los reflejos distorsionados de la ciudad en las ventanas de un rascacielos.', 58000, 'https://images.unsplash.com/photo-1722516822056-675c7b0667de?q=80&w=1664&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 2, '50 x 70 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Danza de la Luz', 'Fotografía abstracta que captura el movimiento de luces en la noche, creando patrones hipnóticos.', 54000, 'https://images.unsplash.com/photo-1719360364265-800592c35006?q=80&w=1571&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 6, '45 x 65 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Arquitectura Orgánica', 'Detalle de un edificio moderno que muestra la fusión entre formas geométricas y orgánicas.', 65000, 'https://images.unsplash.com/photo-1722516820714-06eb6883427c?q=80&w=1664&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 10, '55 x 80 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Microcosmos Floral', 'Macro fotografía que revela los intrincados detalles y colores de una flor exótica.', 49000, 'https://images.unsplash.com/photo-1722516685896-b067f84add14?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 14, '40 x 60 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Soledad Urbana', 'Retrato callejero que captura un momento de introspección en medio del bullicio de la ciudad.', 56000, 'https://images.unsplash.com/photo-1722516768451-9e45a2208651?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 18, '45 x 65 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Geometría Natural', 'Fotografía de un panal de abejas que resalta la perfección geométrica en la naturaleza.', 42000, 'https://images.unsplash.com/photo-1722516820728-3e612f267f52?q=80&w=1664&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 22, '35 x 50 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Fragmetos de Tiempo', 'Composición creativa que yuxtapone elementos antiguos y modernos, reflexionando sobre el paso del tiempo.', 67000, 'https://images.unsplash.com/photo-1719359624039-84041f42853e?q=80&w=1864&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 26, '60 x 85 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Sinfonía de Texturas', 'Collage fotográfico que explora diversas texturas encontradas en la naturaleza y la ciudad.', 73000, 'https://plus.unsplash.com/premium_photo-1708110921185-c58eea479fd3?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 30, '70 x 100 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Equilibrio Perfecto', 'Fotografía minimalista que captura un momento de equilibrio imposible entre objetos cotidianos.', 50000, 'https://plus.unsplash.com/premium_photo-1708110920993-c06183e6e1f4?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 2, '40 x 60 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Esencia del Movimiento', 'Fotografía de larga exposición que captura el flujo de un río, creando patrones suaves y etéreos.', 61000, 'https://images.unsplash.com/photo-1711464669343-2596d0f1b526?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 6, '55 x 75 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Contrastes Urbanos', 'Imagen que yuxtapone la arquitectura antigua y moderna de una ciudad, destacando su evolución.', 70000, 'https://images.unsplash.com/photo-1706344452784-ee1d322ec4b2?q=80&w=1664&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 10, '60 x 90 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Quietud Invernal', 'Paisaje nevado que captura la serenidad y belleza de un bosque en invierno.', 55000, 'https://images.unsplash.com/photo-1518204928-69aa89a61291?q=80&w=1586&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 14, '50 x 70 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Retrato de la Diversidad', 'Serie de retratos que celebra la diversidad humana, capturando rostros de diferentes culturas.', 78000, 'https://images.unsplash.com/photo-1583394885876-f7744b77051f?q=80&w=1636&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 18, '70 x 100 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Abstracciones Líquidas', 'Macro fotografía de gotas de agua, creando formas y reflejos fascinantes.', 48000, 'https://images.unsplash.com/photo-1644193808951-f218ccf1c53c?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 22, '40 x 60 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Metamorfosis Urbana', 'Secuencia de imágenes que muestra la transformación de un espacio urbano a lo largo del tiempo.', 64000, 'https://images.pexels.com/photos/5665104/pexels-photo-5665104.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 26, '60 x 80 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Esencia del Movimiento', 'Fotografía deportiva que captura el dinamismo y la gracia de un atleta en acción.', 53000, 'https://images.pexels.com/photos/206064/pexels-photo-206064.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 30, '45 x 65 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Simetría Perfecta', 'Imagen arquitectónica que resalta la simetría y geometría de un edificio icónico.', 59000, 'https://images.pexels.com/photos/8347501/pexels-photo-8347501.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 2, '50 x 75 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Luces de la Ciudad', 'Fotografía nocturna que captura el brillo y la energía de una metrópolis en la noche.', 72000, 'https://images.pexels.com/photos/1231258/pexels-photo-1231258.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 6, '65 x 90 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Formas de la Naturaleza', 'Estudio fotográfico de patrones y formas encontradas en el mundo natural.', 45000, 'https://images.pexels.com/photos/2449605/pexels-photo-2449605.png?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 10, '40 x 55 cm');



PRODUCTOS DE CATEGORIA Collages

INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Fragmentos de Memoria', 'Collage que combina fotografías vintage y recortes de periódicos para crear una narrativa nostálgica.', 58000, 'https://images.unsplash.com/photo-1557759677-209e5b9103c5?q=80&w=1484&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 3, '50 x 70 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Sueños en Papel', 'Delicado collage que mezcla ilustraciones botánicas y mariposas, creando un jardín onírico.', 45000, 'https://images.unsplash.com/photo-1591788788660-5a345f363d7a?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 8, '40 x 60 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Capas de Realidad', 'Collage digital que superpone imágenes urbanas y naturales, explorando la dualidad del mundo moderno.', 67000, 'https://images.unsplash.com/photo-1625768376472-224b4cbc2ead?q=80&w=1472&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 16, '60 x 80 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Retazos de Identidad', 'Collage que utiliza recortes de revistas para crear un retrato surrealista, explorando temas de identidad.', 53000, 'https://images.unsplash.com/photo-1541359927273-d76820fc43f9?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 21, '45 x 65 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Metamorfosis Urbana', 'Collage que transforma elementos urbanos en un paisaje fantástico, jugando con la escala y la perspectiva.', 71000, 'https://images.unsplash.com/photo-1482160549825-59d1b23cb208?q=80&w=1469&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG29by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 27, '70 x 100 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Ecos del Pasado', 'Collage que combina fotografías antiguas y elementos modernos para crear un diálogo entre épocas.', 49000, 'https://images.unsplash.com/photo-1562388364-cfca9bff0b41?q=80&w=1454&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 5, '40 x 55 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Naturaleza Fragmentada', 'Collage que descompone y reconstruye imágenes de la naturaleza, creando un mosaico visual fascinante.', 62000, 'https://images.unsplash.com/photo-1549144277-47d96d572dc4?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 13, '55 x 75 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Sueños en Technicolor', 'Vibrante collage digital que mezcla elementos pop art con imágenes surrealistas.', 76000, 'https://images.unsplash.com/photo-1562755918-d4fa85ac239f?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 19, '80 x 120 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Cartografía del Alma', 'Collage introspectivo que utiliza mapas, texto y imágenes personales para crear un paisaje emocional.', 57000, 'https://images.unsplash.com/photo-1583407727557-c3cbea1bea54?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 25, '50 x 70 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Caleidoscopio Urbano', 'Collage que transforma escenas urbanas en un patrón caleidoscópico, jugando con la simetría y el color.', 68000, 'https://images.unsplash.com/photo-1597658917821-e3e00bd9eab0?q=80&w=1472&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 9, '60 x 90 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Anatomía de un Sueño', 'Collage surrealista que explora el subconsciente, combinando elementos anatómicos y paisajes oníricos.', 72000, 'https://images.unsplash.com/photo-1619199037745-bcc49b4afb0a?q=80&w=1488&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 17, '65 x 95 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Fusión Temporal', 'Collage que mezcla imágenes históricas y futuristas, creando un puente visual entre pasado y futuro.', 59000, 'https://images.unsplash.com/photo-1706931333738-87738429e35b?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 23, '55 x 75 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Ecosistema Imaginario', 'Collage que crea un mundo fantástico combinando elementos de diferentes hábitats naturales.', 64000, 'https://images.unsplash.com/photo-1604513836142-30e79a55bd35?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 7, '60 x 80 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Sinfonía Visual', 'Collage abstracto inspirado en la música, traduciendo ritmos y melodías en formas y colores.', 55000, 'https://images.unsplash.com/photo-1547750588-51ce0c34f651?q=80&w=1472&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 11, '50 x 65 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Fragmentos de Viaje', 'Collage que reconstruye memorias de viajes utilizando mapas, tickets y fotografías personales.', 47000, 'https://images.unsplash.com/photo-1622084169340-cab9cac7fb26?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 29, '40 x 60 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Metamorfosis Natural', 'Collage que explora el ciclo de la vida en la naturaleza, desde el nacimiento hasta la descomposición.', 69000, 'https://images.unsplash.com/photo-1569510816350-2796c5e0da87?q=80&w=1548&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 15, '65 x 85 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Ciudades Imposibles', 'Collage arquitectónico que crea paisajes urbanos surreales combinando edificios de diferentes estilos y épocas.', 74000, 'https://images.unsplash.com/photo-1619199085322-4c53cd04e5ec?q=80&w=1496&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 3, '70 x 100 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Galaxias Interiores', 'Collage que fusiona imágenes microscópicas y astronómicas, explorando los paralelos entre lo micro y lo macro.', 66000, 'https://images.unsplash.com/photo-1592795694700-d3ac8a1e2f19?q=80&w=1619&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 8, '60 x 85 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Retratos Fragmentados', 'Serie de retratos creados a partir de fragmentos de diferentes rostros, cuestionando la identidad.', 61000, 'https://images.unsplash.com/photo-1581300741129-49680ba5ecc6?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 16, '55 x 75 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Evolución Tecnológica', 'Collage que traza la evolución de la tecnología, desde herramientas primitivas hasta dispositivos futuristas.', 70000, 'https://images.unsplash.com/photo-1545385662-40d6ce7ceab0?q=80&w=1600&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 21, '65 x 95 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Paisajes Emocionales', 'Collage abstracto que representa diferentes estados emocionales a través de color y textura.', 52000, 'https://images.unsplash.com/photo-1620907308590-c8d3a9a3b691?q=80&w=1498&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 27, '45 x 65 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Simetría Caótica', 'Collage que juega con la percepción creando patrones simétricos a partir de elementos caóticos y dispares.', 63000, 'https://images.unsplash.com/photo-1597658917821-e3e00bd9eab0?q=80&w=1472&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 5, '60 x 80 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Ventanas al Subconsciente', 'Collage surrealista que explora el mundo de los sueños y el inconsciente a través de yuxtaposiciones inesperadas.', 68000, 'https://images.unsplash.com/photo-1569294431965-6bec2954819e?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 13, '65 x 90 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Cronología Abstracta', 'Collage que representa el paso del tiempo de manera abstracta, combinando relojes, calendarios y símbolos temporales.', 57000, 'https://images.unsplash.com/photo-1570370433373-bfd0b4421c87?q=80&w=1472&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 19, '50 x 70 cm');


PRODUCTOS DE CATEGORIA Pinturas

INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Explosión Cromática', 'Pintura abstracta que explora la interacción dinámica entre colores vibrantes y formas fluidas.', 68000, 'https://images.pexels.com/photos/25754284/pexels-photo-25754284/free-photo-of-arte-pintura-pintando-cuadro.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 4, '80 x 100 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Serenidad Acuática', 'Paisaje marítimo que captura la tranquilidad del océano al atardecer, con tonos suaves y reflejos dorados.', 55000, 'https://images.unsplash.com/photo-1706282540364-962e8b1543da?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 12, '60 x 80 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Retrato del Alma', 'Retrato expresionista que revela las profundidades emocionales del sujeto a través de pinceladas audaces y colores intensos.', 72000, 'https://images.unsplash.com/photo-1619535542434-15a286fdb0ce?q=80&w=1590&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 20, '70 x 90 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Sinfonía de la Naturaleza', 'Paisaje impresionista que celebra la belleza de un campo de flores silvestres en plena floración.', 63000, 'https://images.unsplash.com/photo-1619535542157-77b5c650347d?q=80&w=1603&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 28, '75 x 95 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Geometría Urbana', 'Pintura abstracta que interpreta la ciudad moderna a través de formas geométricas y una paleta de colores contrastantes.', 59000, 'https://images.unsplash.com/photo-1669038045897-3869080bf458?q=80&w=1694&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 7, '65 x 85 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Danza de las Sombras', 'Obra en blanco y negro que explora el juego de luz y sombra en un escenario abstracto y misterioso.', 51000, 'https://images.unsplash.com/photo-1701189701778-7bb8d81549d8?q=80&w=1588&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 15, '55 x 75 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Fragmentos de Memoria', 'Collage pictórico que combina elementos realistas y abstractos para evocar recuerdos y emociones del pasado.', 67000, 'https://images.unsplash.com/photo-1628716779718-b68b4b1968fb?q=80&w=1582&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 23, '70 x 90 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Horizonte Onírico', 'Paisaje surrealista que fusiona elementos terrestres y celestiales en una visión de ensueño.', 76000, 'https://images.unsplash.com/photo-1706266541244-89bfdd5ad021?q=80&w=1648&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 9, '90 x 120 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Metamorfosis Floral', 'Estudio botánico artístico que captura la transformación de una flor desde el capullo hasta la plena floración.', 54000, 'https://images.unsplash.com/photo-1705427732313-eb9704fcee3f?q=80&w=1584&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 17, '50 x 70 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Abstracción Líquida', 'Pintura abstracta que evoca el movimiento fluido del agua con una paleta de azules y verdes.', 62000, 'https://images.pexels.com/photos/25757980/pexels-photo-25757980/free-photo-of-arte-pintura-pintando-cuadro.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 25, '70 x 90 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Energía Primordial', 'Obra abstracta que explora la fuerza y el dinamismo de la naturaleza a través de pinceladas expresivas y colores intensos.', 69000, 'https://images.pexels.com/photos/25748099/pexels-photo-25748099/free-photo-of-arte-pintura-pintando-cuadro.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 5, '80 x 100 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Calma Azul', 'Pintura minimalista que evoca una sensación de paz y tranquilidad a través de sutiles variaciones de azul.', 47000, 'https://images.pexels.com/photos/25751900/pexels-photo-25751900/free-photo-of-arte-azul-pintura-pintando.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 13, '60 x 80 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Retrato de lo Efímero', 'Naturaleza muerta contemporánea que explora la belleza y fragilidad de objetos cotidianos.', 58000, 'https://images.pexels.com/photos/13664121/pexels-photo-13664121.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 21, '65 x 85 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Ventana al Pasado', 'Pintura realista que captura la nostalgia y el encanto de una escena urbana vintage.', 73000, 'https://images.pexels.com/photos/4406719/pexels-photo-4406719.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 29, '75 x 95 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Sinfonía Cromática', 'Explosión de color y forma que celebra la alegría y la vitalidad de la expresión artística pura.', 65000, 'https://images.pexels.com/photos/1266808/pexels-photo-1266808.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 8, '70 x 90 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Reflejos del Alma', 'Retrato expresionista que utiliza colores vibrantes para revelar la personalidad interior del sujeto.', 71000, 'https://images.pexels.com/photos/1589279/pexels-photo-1589279.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 16, '80 x 100 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Susurros del Bosque', 'Paisaje atmosférico que captura la magia y el misterio de un bosque al amanecer.', 56000, 'https://images.pexels.com/photos/5415778/pexels-photo-5415778.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 24, '65 x 85 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Geometría Sagrada', 'Composición abstracta inspirada en patrones matemáticos y formas geométricas encontradas en la naturaleza.', 60000, 'https://images.pexels.com/photos/1981468/pexels-photo-1981468.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 11, '70 x 70 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Danza de Colores', 'Pintura abstracta que celebra el movimiento y la interacción dinámica entre formas y colores.', 64000, 'https://images.pexels.com/photos/1269968/pexels-photo-1269968.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 19, '75 x 95 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Eco del Pasado', 'Pintura que combina elementos contemporáneos y históricos para crear un diálogo entre diferentes épocas.', 70000, 'https://images.pexels.com/photos/1585325/pexels-photo-1585325.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 27, '85 x 110 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Serenidad Abstracta', 'Obra minimalista que explora la paz y la calma a través de formas suaves y colores neutros.', 52000, 'https://images.pexels.com/photos/7004697/pexels-photo-7004697.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 6, '60 x 80 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Fusión Urbana', 'Pintura que mezcla elementos de street art y técnicas clásicas para retratar la vida urbana contemporánea.', 66000, 'https://images.pexels.com/photos/1561020/pexels-photo-1561020.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 14, '75 x 95 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Ecos de la Tierra', 'Paisaje abstracto inspirado en las texturas y colores de formaciones geológicas.', 61000, 'https://images.pexels.com/photos/1572386/pexels-photo-1572386.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 22, '70 x 90 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Melodía Visual', 'Interpretación pictórica de una pieza musical, traduciendo sonidos en colores y formas.', 57000, 'https://images.pexels.com/photos/1266808/pexels-photo-1266808.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 30, '65 x 85 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Naturaleza Muerta Moderna', 'Reinterpretación contemporánea del género de naturaleza muerta, con un toque surrealista.', 53000, 'https://images.pexels.com/photos/25478707/pexels-photo-25478707/free-photo-of-plato-arte-botellas-aves.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 3, '55 x 75 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Capas de Realidad', 'Pintura que explora la percepción y la realidad a través de capas superpuestas de imágenes.', 75000, 'https://images.pexels.com/photos/25639480/pexels-photo-25639480/free-photo-of-arte-pintura-pintando-cuadro.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 10, '90 x 120 cm');
INSERT INTO products (title, description, price, url_image, seller_id, format) VALUES
('Textura Emocional', 'Obra abstracta que utiliza técnicas de empaste para crear una superficie rica en textura, evocando emociones a través del tacto visual.', 68000, 'https://images.pexels.com/photos/25565872/pexels-photo-25565872/free-photo-of-arte-textura-pintura-pintando.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 18, '75 x 95 cm');


EJEMPLOS

INSERT INTO categories (name) VALUES ('Ilustraciones');
INSERT INTO categories (name) VALUES ('Fotografías');
INSERT INTO categories (name) VALUES ('Collages');
INSERT INTO categories (name) VALUES ('Pinturas');
INSERT INTO categories (name) VALUES ('Fanzines');
INSERT INTO categories (name) VALUES ('Escritos');

PRODUCTOS DE CATEGORIA ILUSTRACIONES

INSERT INTO products_categories (product_id, category_id) VALUES (1, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (2, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (3, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (4, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (5, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (6, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (7, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (8, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (9, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (10, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (11, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (12, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (13, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (14, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (15, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (16, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (17, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (18, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (19, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (20, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (21, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (22, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (23, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (24, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (25, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (26, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (27, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (28, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (29, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (30, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (31, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (32, 1);
INSERT INTO products_categories (product_id, category_id) VALUES (33, 1);

PRODUCTOS DE CATEGORIA FOTOGRAFIAS

INSERT INTO products_categories (product_id, category_id) VALUES (34, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (35, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (36, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (37, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (38, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (39, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (40, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (41, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (42, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (43, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (44, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (45, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (46, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (47, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (48, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (49, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (50, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (51, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (52, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (53, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (54, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (55, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (56, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (57, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (58, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (59, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (60, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (61, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (62, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (63, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (64, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (65, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (66, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (67, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (68, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (69, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (70, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (71, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (72, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (73, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (74, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (75, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (76, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (77, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (78, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (79, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (80, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (81, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (82, 2);
INSERT INTO products_categories (product_id, category_id) VALUES (83, 2);

PRODUCTOS DE CATEGORIA COLLAGES

INSERT INTO products_categories (product_id, category_id) VALUES (84, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (85, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (86, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (87, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (88, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (89, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (90, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (91, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (92, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (93, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (94, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (95, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (96, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (97, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (98, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (99, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (100, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (101, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (102, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (103, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (104, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (105, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (106, 5);
INSERT INTO products_categories (product_id, category_id) VALUES (107, 5);


PRODUCTO DE CATEGORIA PINTURAS

INSERT INTO products_categories (product_id, category_id) VALUES (108, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (109, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (110, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (111, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (112, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (113, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (114, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (115, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (116, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (117, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (118, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (119, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (120, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (121, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (122, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (123, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (124, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (125, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (126, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (127, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (128, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (129, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (130, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (131, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (132, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (133, 6);
INSERT INTO products_categories (product_id, category_id) VALUES (134, 6);



AGREGANDO INSPIRATION Y MATERIALS A CADA PRODUCTO

-- Actualizaciones para Ilustraciones (product_id del 1 al 33)
UPDATE products SET inspiration = 'Sueños recurrentes del artista', materials = 'Acuarela sobre papel de algodón' WHERE product_id = 1;
UPDATE products SET inspiration = 'Arquitectura moderna de grandes ciudades', materials = 'Tinta y marcadores sobre papel bristol' WHERE product_id = 2;
UPDATE products SET inspiration = 'Patrones fractales en la naturaleza', materials = 'Técnica mixta: acrílico y lápices de colores' WHERE product_id = 3;
UPDATE products SET inspiration = 'Estudio de la expresión facial humana', materials = 'Lápiz grafito sobre papel texturizado' WHERE product_id = 4;
UPDATE products SET inspiration = 'Teorías sobre el multiverso', materials = 'Tinta china y plumilla sobre papel de acuarela' WHERE product_id = 5;
UPDATE products SET inspiration = 'Estados emocionales y su representación visual', materials = 'Pasteles secos sobre papel negro' WHERE product_id = 6;
UPDATE products SET inspiration = 'Estudios botánicos del siglo XVIII', materials = 'Lápices de colores sobre papel vegetal' WHERE product_id = 7;
UPDATE products SET inspiration = 'Visiones futuristas de ciudades flotantes', materials = 'Técnica digital con tableta gráfica' WHERE product_id = 8;
UPDATE products SET inspiration = 'Ciclo de vida de las mariposas', materials = 'Acuarela y tinta sobre papel de arroz' WHERE product_id = 9;
UPDATE products SET inspiration = 'Mapas estelares antiguos', materials = 'Gouache y tinta dorada sobre cartulina negra' WHERE product_id = 10;
UPDATE products SET inspiration = 'Memorias de infancia del artista', materials = 'Collage digital y dibujo a mano' WHERE product_id = 11;
UPDATE products SET inspiration = 'Fotografías microscópicas de células', materials = 'Acrílico fluorescente sobre lienzo' WHERE product_id = 12;
UPDATE products SET inspiration = 'Movimientos de danza contemporánea', materials = 'Carboncillo y pastel sobre papel kraft' WHERE product_id = 13;
UPDATE products SET inspiration = 'Cartografía imaginaria de mundos de fantasía', materials = 'Acuarela, tinta y café sobre pergamino' WHERE product_id = 14;
UPDATE products SET inspiration = 'Estructuras microscópicas de minerales', materials = 'Tinta de alcohol y marcadores metálicos' WHERE product_id = 15;
UPDATE products SET inspiration = 'Sinestesia: visualización de sonidos', materials = 'Técnica mixta: acuarela y tinta sobre yupo' WHERE product_id = 16;
UPDATE products SET inspiration = 'Jardines secretos y laberintos', materials = 'Rotuladores y lápices de colores sobre papel' WHERE product_id = 17;
UPDATE products SET inspiration = 'Patrones en movimiento del agua', materials = 'Acrílico líquido y tinta sobre papel sintético' WHERE product_id = 18;
UPDATE products SET inspiration = 'Etapas de la vida representadas simbólicamente', materials = 'Lápiz grafito y acuarela sobre papel de algodón' WHERE product_id = 19;
UPDATE products SET inspiration = 'Bestiarios medievales', materials = 'Tinta china y acuarela sobre papel envejecido' WHERE product_id = 20;
UPDATE products SET inspiration = 'Mapas topográficos de lugares imaginarios', materials = 'Lápices de colores y tinta sobre papel texturizado' WHERE product_id = 21;
UPDATE products SET inspiration = 'Patrones fractales en la naturaleza', materials = 'Pluma estilográfica y acuarela sobre papel' WHERE product_id = 22;
UPDATE products SET inspiration = 'Literatura steampunk', materials = 'Tinta, acuarela y collage sobre cartón' WHERE product_id = 23;
UPDATE products SET inspiration = 'Teorías de la física cuántica', materials = 'Técnica digital con renderizado 3D' WHERE product_id = 24;
UPDATE products SET inspiration = 'Mitología personal del artista', materials = 'Gouache y tinta sobre papel negro' WHERE product_id = 25;
UPDATE products SET inspiration = 'Estudios sobre la sinestesia', materials = 'Acrílico y tinta sobre lienzo' WHERE product_id = 26;
UPDATE products SET inspiration = 'Mapas del cerebro humano', materials = 'Rotuladores y lápices sobre papel de acuarela' WHERE product_id = 27;
UPDATE products SET inspiration = 'Constelaciones y mitología griega', materials = 'Tinta plateada y dorada sobre papel negro' WHERE product_id = 28;
UPDATE products SET inspiration = 'Ecosistemas en miniatura', materials = 'Acuarela y lápiz sobre papel de algodón' WHERE product_id = 29;
UPDATE products SET inspiration = 'Tipografía experimental y caligrafía', materials = 'Tinta china y plumilla sobre papel de arroz' WHERE product_id = 30;
UPDATE products SET inspiration = 'Viajes oníricos a mundos surreales', materials = 'Técnica mixta: acuarela, tinta y digital' WHERE product_id = 31;
UPDATE products SET inspiration = 'Metamorfosis de formas geométricas', materials = 'Ilustración digital con efectos de textura' WHERE product_id = 32;
UPDATE products SET inspiration = 'Lenguaje visual de emociones complejas', materials = 'Lápices de colores y tinta sobre papel texturizado' WHERE product_id = 33;
-- Actualizaciones para Fotografías (product_id del 34 al 83)
UPDATE products SET inspiration = 'La quietud de los paisajes invernales', materials = 'Impresión en papel fotográfico de archivo' WHERE product_id = 34;
UPDATE products SET inspiration = 'Reflejos urbanos después de la lluvia', materials = 'Impresión en aluminio dibond' WHERE product_id = 35;
UPDATE products SET inspiration = 'Patrones y texturas en la naturaleza', materials = 'Impresión en papel de algodón fine art' WHERE product_id = 36;
UPDATE products SET inspiration = 'Movimiento y color en estado líquido', materials = 'Impresión en metacrilato de alta definición' WHERE product_id = 37;
UPDATE products SET inspiration = 'La energía nocturna de las grandes ciudades', materials = 'Impresión en papel baritado' WHERE product_id = 38;
UPDATE products SET inspiration = 'Explosiones de color en la naturaleza', materials = 'Impresión cromógena sobre papel metálico' WHERE product_id = 39;
UPDATE products SET inspiration = 'Geometría en la arquitectura moderna', materials = 'Impresión en lienzo tensado' WHERE product_id = 40;
UPDATE products SET inspiration = 'La serenidad de los amaneceres costeros', materials = 'Impresión fine art en papel de algodón' WHERE product_id = 41;
UPDATE products SET inspiration = 'Texturas y patrones en arquitectura antigua', materials = 'Impresión en papel japonés washi' WHERE product_id = 42;
UPDATE products SET inspiration = 'La física del agua en movimiento', materials = 'Impresión en metacrilato con respaldo de aluminio' WHERE product_id = 43;
UPDATE products SET inspiration = 'Perspectivas aéreas de paisajes urbanos', materials = 'Impresión en papel fotográfico pearl' WHERE product_id = 44;
UPDATE products SET inspiration = 'Movimiento de luces nocturnas', materials = 'Impresión en papel de fibra baritada' WHERE product_id = 45;
UPDATE products SET inspiration = 'La profundidad de la mirada humana', materials = 'Impresión en papel de algodón texturizado' WHERE product_id = 46;
UPDATE products SET inspiration = 'Minimalismo en la arquitectura', materials = 'Impresión en dibond de aluminio' WHERE product_id = 47;
UPDATE products SET inspiration = 'Juego de sombras en espacios urbanos', materials = 'Impresión en papel fotográfico mate' WHERE product_id = 48;
UPDATE products SET inspiration = 'Detalles microscópicos de la flora', materials = 'Impresión en papel de acuarela' WHERE product_id = 49;
UPDATE products SET inspiration = 'La vastedad de los paisajes desérticos', materials = 'Impresión panorámica en papel fine art' WHERE product_id = 50;
UPDATE products SET inspiration = 'Nostalgia y cultura del automóvil', materials = 'Impresión vintage en papel envejecido' WHERE product_id = 51;
UPDATE products SET inspiration = 'Patrones y colores en minerales', materials = 'Impresión en metacrilato de alta definición' WHERE product_id = 52;
UPDATE products SET inspiration = 'La geometría natural de los campos de flores', materials = 'Impresión en lienzo con tintas pigmentadas' WHERE product_id = 53;
UPDATE products SET inspiration = 'Texturas y patrones en cortezas de árboles', materials = 'Impresión en papel de algodón texturizado' WHERE product_id = 54;
UPDATE products SET inspiration = 'Simetría en insectos exóticos', materials = 'Impresión macro en papel fotográfico pearl' WHERE product_id = 55;
UPDATE products SET inspiration = 'La belleza submarina de los arrecifes', materials = 'Impresión en papel resistente al agua' WHERE product_id = 56;
UPDATE products SET inspiration = 'Vuelo y libertad de las aves', materials = 'Impresión en papel fotográfico mate' WHERE product_id = 57;
UPDATE products SET inspiration = 'Transición del día a la noche en la ciudad', materials = 'Impresión en aluminio con acabado brillante' WHERE product_id = 58;
UPDATE products SET inspiration = 'La inocencia y pureza de la infancia', materials = 'Impresión en papel de algodón fine art' WHERE product_id = 59;
UPDATE products SET inspiration = 'Movimiento de las estrellas en el cielo nocturno', materials = 'Impresión de larga exposición en papel metalizado' WHERE product_id = 60;
UPDATE products SET inspiration = 'Patrones en maquinaria industrial', materials = 'Impresión en blanco y negro sobre papel baritado' WHERE product_id = 61;
UPDATE products SET inspiration = 'Dramáticos cielos post-tormenta', materials = 'Impresión HDR en papel de archivo' WHERE product_id = 62;
UPDATE products SET inspiration = 'Patrones geométricos en cristales de hielo', materials = 'Impresión macro en papel fine art' WHERE product_id = 63;
UPDATE products SET inspiration = 'La fuerza y movimiento del océano', materials = 'Impresión en metacrilato resistente al agua' WHERE product_id = 64;
UPDATE products SET inspiration = 'Juego de luz y sombra al atardecer', materials = 'Impresión en papel fotográfico mate' WHERE product_id = 65;
UPDATE products SET inspiration = 'Reflejos distorsionados en arquitectura moderna', materials = 'Impresión en aluminio cepillado' WHERE product_id = 66;
UPDATE products SET inspiration = 'Movimiento de luces en la noche urbana', materials = 'Impresión de larga exposición en papel metálico' WHERE product_id = 67;
UPDATE products SET inspiration = 'Fusión de formas orgánicas y geométricas en arquitectura', materials = 'Impresión en lienzo tensado' WHERE product_id = 68;
UPDATE products SET inspiration = 'Detalles microscópicos de flores exóticas', materials = 'Impresión macro en papel de algodón' WHERE product_id = 69;
UPDATE products SET inspiration = 'La soledad en medio del bullicio urbano', materials = 'Impresión en blanco y negro sobre papel baritado' WHERE product_id = 70;
UPDATE products SET inspiration = 'Geometría perfecta en la naturaleza', materials = 'Impresión en papel fotográfico de alta resolución' WHERE product_id = 71;
UPDATE products SET inspiration = 'Contraste entre lo antiguo y lo moderno', materials = 'Impresión en papel envejecido artificialmente' WHERE product_id = 72;
UPDATE products SET inspiration = 'Diversidad de texturas en la naturaleza y la ciudad', materials = 'Impresión en papel texturizado fine art' WHERE product_id = 73;
UPDATE products SET inspiration = 'Equilibrio imposible en objetos cotidianos', materials = 'Impresión en papel fotográfico pearl' WHERE product_id = 74;
UPDATE products SET inspiration = 'Fluidez y movimiento del agua', materials = 'Impresión de larga exposición en papel satinado' WHERE product_id = 75;
UPDATE products SET inspiration = 'Evolución arquitectónica de la ciudad', materials = 'Impresión en panel composite de aluminio' WHERE product_id = 76;
UPDATE products SET inspiration = 'La quietud de los bosques invernales', materials = 'Impresión en papel de algodón texturizado' WHERE product_id = 77;
UPDATE products SET inspiration = 'Diversidad y belleza de rostros humanos', materials = 'Impresión en papel fotográfico profesional' WHERE product_id = 78;
UPDATE products SET inspiration = 'Patrones y reflejos en gotas de agua', materials = 'Impresión macro en metacrilato de alta definición' WHERE product_id = 79;
UPDATE products SET inspiration = 'Transformación de espacios urbanos a lo largo del tiempo', materials = 'Impresión en papel de archivo resistente al desvanecimiento' WHERE product_id = 80;
UPDATE products SET inspiration = 'Abstracción en movimientos naturales', materials = 'Impresión fine art en papel de bambú' WHERE product_id = 81;
UPDATE products SET inspiration = 'La poesía visual de la niebla en el paisaje', materials = 'Impresión en papel japonés gampi' WHERE product_id = 82;
UPDATE products SET inspiration = 'Microexpresiones faciales en retratos íntimos', materials = 'Impresión en papel de algodón con tintas de pigmento' WHERE product_id = 83;
-- Continuación de Actualizaciones para Collages (product_id del 84 al 107)
UPDATE products SET inspiration = 'Recuerdos fragmentados de la infancia', materials = 'Papel vintage, fotografías antiguas, hilo' WHERE product_id = 84;
UPDATE products SET inspiration = 'La delicadeza y fragilidad de la naturaleza', materials = 'Papel de acuarela, recortes botánicos, tinta' WHERE product_id = 85;
UPDATE products SET inspiration = 'Contraste entre lo natural y lo artificial', materials = 'Fotografías impresas, papel de revista, acrílico' WHERE product_id = 86;
UPDATE products SET inspiration = 'Exploración de la identidad personal', materials = 'Recortes de revistas, tela, pintura en spray' WHERE product_id = 87;
UPDATE products SET inspiration = 'Caos y orden en el entorno urbano', materials = 'Mapas, tickets, fotografías urbanas, acuarela' WHERE product_id = 88;
UPDATE products SET inspiration = 'Diálogo entre el pasado y el presente', materials = 'Fotografías antiguas, recortes de periódicos modernos' WHERE product_id = 89;
UPDATE products SET inspiration = 'La interconexión de todos los seres vivos', materials = 'Ilustraciones botánicas, papel de seda, hilo dorado' WHERE product_id = 90;
UPDATE products SET inspiration = 'Sueños y realidad en la cultura pop', materials = 'Recortes de cómics, papel brillante, pintura acrílica' WHERE product_id = 91;
UPDATE products SET inspiration = 'Cartografía emocional de experiencias personales', materials = 'Mapas antiguos, diarios personales, acuarela' WHERE product_id = 92;
UPDATE products SET inspiration = 'Patrones y simetrías en la naturaleza y la ciudad', materials = 'Fotografías impresas, papel metálico, tinta' WHERE product_id = 93;
UPDATE products SET inspiration = 'El subconsciente y los sueños', materials = 'Recortes de revistas, tela, objetos encontrados' WHERE product_id = 94;
UPDATE products SET inspiration = 'Evolución tecnológica y su impacto', materials = 'Circuitos impresos, papel de aluminio, acrílico' WHERE product_id = 95;
UPDATE products SET inspiration = 'Fusión de épocas históricas', materials = 'Grabados antiguos, fotografías modernas, gouache' WHERE product_id = 96;
UPDATE products SET inspiration = 'Ecosistemas imaginarios', materials = 'Papel reciclado, hojas secas, tinta china' WHERE product_id = 97;
UPDATE products SET inspiration = 'La música visualizada', materials = 'Partituras, vinilos cortados, pintura metálica' WHERE product_id = 98;
UPDATE products SET inspiration = 'Memorias de viajes', materials = 'Mapas, tickets, sellos, acuarela' WHERE product_id = 99;
UPDATE products SET inspiration = 'Ciclos de la naturaleza', materials = 'Papel de arroz, semillas, pigmentos naturales' WHERE product_id = 100;
UPDATE products SET inspiration = 'Arquitectura imposible', materials = 'Planos arquitectónicos, fotografías, lápiz' WHERE product_id = 101;
UPDATE products SET inspiration = 'Microcosmos y macrocosmos', materials = 'Fotografías microscópicas, mapas estelares, tinta' WHERE product_id = 102;
UPDATE products SET inspiration = 'Identidades fragmentadas', materials = 'Recortes de retratos, espejos rotos, hilo' WHERE product_id = 103;
UPDATE products SET inspiration = 'Evolución de la comunicación', materials = 'Recortes de periódicos, códigos QR, pintura acrílica' WHERE product_id = 104;
UPDATE products SET inspiration = 'Paisajes emocionales', materials = 'Papel de color, tela, pintura en aerosol' WHERE product_id = 105;
UPDATE products SET inspiration = 'Simetría en el caos', materials = 'Fotografías recortadas, papel de origami, tinta' WHERE product_id = 106;
UPDATE products SET inspiration = 'Ventanas al inconsciente', materials = 'Negativos fotográficos, acetato, pintura acrílica' WHERE product_id = 107;
-- Actualizaciones para Pinturas (product_id del 108 al 134)
UPDATE products SET inspiration = 'Explosión de emociones internas', materials = 'Óleo sobre lienzo' WHERE product_id = 108;
UPDATE products SET inspiration = 'La serenidad del mar al atardecer', materials = 'Acrílico sobre panel de madera' WHERE product_id = 109;
UPDATE products SET inspiration = 'Profundidad del alma humana', materials = 'Óleo y técnica mixta sobre lienzo' WHERE product_id = 110;
UPDATE products SET inspiration = 'La vitalidad de la naturaleza en primavera', materials = 'Acrílico y pastel sobre lienzo' WHERE product_id = 111;
UPDATE products SET inspiration = 'Abstracción de la vida urbana', materials = 'Óleo y collage sobre lienzo' WHERE product_id = 112;
UPDATE products SET inspiration = 'Dualidad entre luz y oscuridad', materials = 'Acrílico y tinta sobre papel' WHERE product_id = 113;
UPDATE products SET inspiration = 'Fragmentos de recuerdos olvidados', materials = 'Técnica mixta sobre madera' WHERE product_id = 114;
UPDATE products SET inspiration = 'Sueños y realidades alternativas', materials = 'Óleo sobre lienzo de gran formato' WHERE product_id = 115;
UPDATE products SET inspiration = 'Metamorfosis de la naturaleza', materials = 'Acuarela y tinta sobre papel de algodón' WHERE product_id = 116;
UPDATE products SET inspiration = 'Fluidez y movimiento del agua', materials = 'Acrílico sobre lienzo texturizado' WHERE product_id = 117;
UPDATE products SET inspiration = 'Energía primordial del universo', materials = 'Óleo y pigmentos metálicos sobre lienzo' WHERE product_id = 118;
UPDATE products SET inspiration = 'Meditación y calma interior', materials = 'Acrílico y arena sobre lienzo' WHERE product_id = 119;
UPDATE products SET inspiration = 'La fugacidad del tiempo', materials = 'Óleo y técnica mixta sobre panel' WHERE product_id = 120;
UPDATE products SET inspiration = 'Nostalgia de épocas pasadas', materials = 'Óleo sobre lienzo envejecido' WHERE product_id = 121;
UPDATE products SET inspiration = 'Sinfonía de color y forma', materials = 'Acrílico y spray sobre lienzo' WHERE product_id = 122;
UPDATE products SET inspiration = 'El poder de la mirada humana', materials = 'Óleo sobre lienzo de lino' WHERE product_id = 123;
UPDATE products SET inspiration = 'Geometría sagrada en la naturaleza', materials = 'Acrílico y pan de oro sobre madera' WHERE product_id = 124;
UPDATE products SET inspiration = 'Danza de colores y emociones', materials = 'Óleo y espátula sobre lienzo' WHERE product_id = 125;
UPDATE products SET inspiration = 'Diálogo entre pasado y presente', materials = 'Técnica mixta sobre lienzo antiguo' WHERE product_id = 126;
UPDATE products SET inspiration = 'Calma y equilibrio zen', materials = 'Acrílico y tinta china sobre papel de arroz' WHERE product_id = 127;
UPDATE products SET inspiration = 'Fusión de culturas urbanas', materials = 'Spray y acrílico sobre muro (reproducción en lienzo)' WHERE product_id = 128;
UPDATE products SET inspiration = 'Texturas y capas de la Tierra', materials = 'Óleo y materiales naturales sobre lienzo' WHERE product_id = 129;
UPDATE products SET inspiration = 'Armonía musical visualizada', materials = 'Acrílico y resina sobre panel de madera' WHERE product_id = 130;
UPDATE products SET inspiration = 'Objetos cotidianos reimaginados', materials = 'Óleo y objetos encontrados sobre lienzo' WHERE product_id = 131;
UPDATE products SET inspiration = 'La poesía del movimiento', materials = 'Acrílico fluido sobre lienzo' WHERE product_id = 132;
UPDATE products SET inspiration = 'Capas de realidad y percepción', materials = 'Óleo y collage digital impreso sobre lienzo' WHERE product_id = 133;
UPDATE products SET inspiration = 'Texturas emocionales abstractas', materials = 'Acrílico con técnica de empaste sobre lienzo' WHERE product_id = 134;


















