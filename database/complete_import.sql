-- =============================================
-- E-Commerce Database - Complete Import Script
-- Database: ecommerce_db
-- Version: 1.0
-- Created: January 2026
-- 
-- This script creates the database schema and imports seed data
-- Run this file to set up the complete database
-- =============================================

-- =============================================
-- DROP AND CREATE DATABASE
-- =============================================
DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce_db;

-- =============================================
-- Table: users
-- Description: Customer and admin user accounts
-- =============================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role ENUM('user', 'admin') DEFAULT 'user',
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: categories
-- Description: Product categories
-- =============================================
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: products
-- Description: Product catalog with inventory
-- =============================================
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    image_url VARCHAR(500),
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT,
    INDEX idx_category (category_id),
    INDEX idx_active (is_active),
    INDEX idx_price (price),
    INDEX idx_name (name),
    INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: orders
-- Description: Customer orders
-- =============================================
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    customer_phone VARCHAR(20) NOT NULL,
    shipping_address TEXT,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user (user_id),
    INDEX idx_email (customer_email),
    INDEX idx_status (status),
    INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: order_items
-- Description: Line items for each order
-- =============================================
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    INDEX idx_order (order_id),
    INDEX idx_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: cart_items
-- Description: Shopping cart items for logged-in users
-- =============================================
CREATE TABLE cart_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product (user_id, product_id),
    INDEX idx_user (user_id),
    INDEX idx_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- SEED DATA - Users (Test Accounts)
-- =============================================
-- Password for all test accounts: Password123!
-- Note: In production, use proper bcrypt hashing with higher cost factor
INSERT INTO users (email, password_hash, full_name, phone, role, is_active) VALUES
-- Admin Accounts
('admin@ecommerce.com', '$2a$10$rZ9pJWxH5kqVQzB5g1PNnOYxJ1nB5QzB5g1PNnOYxJ1nB5QzB5g1P', 'Admin User', '+1234567890', 'admin', 1),
('superadmin@ecommerce.com', '$2a$10$rZ9pJWxH5kqVQzB5g1PNnOYxJ1nB5QzB5g1PNnOYxJ1nB5QzB5g1P', 'Super Admin', '+1234567891', 'admin', 1),

-- Regular User Accounts
('user@example.com', '$2a$10$rZ9pJWxH5kqVQzB5g1PNnOYxJ1nB5QzB5g1PNnOYxJ1nB5QzB5g1P', 'John Doe', '+1234567892', 'user', 1),
('jane.smith@example.com', '$2a$10$rZ9pJWxH5kqVQzB5g1PNnOYxJ1nB5QzB5g1PNnOYxJ1nB5QzB5g1P', 'Jane Smith', '+1234567893', 'user', 1),
('testuser@ecommerce.com', '$2a$10$rZ9pJWxH5kqVQzB5g1PNnOYxJ1nB5QzB5g1PNnOYxJ1nB5QzB5g1P', 'Test User', '+1234567894', 'user', 1);

-- =============================================
-- SEED DATA - Categories
-- =============================================
INSERT INTO categories (name, description, image_url) VALUES
('Pakaian', 'Fashion pakaian pria dan wanita', 'Assets/fashionsale.jpg'),
('Sepatu & Sandal', 'Koleksi sepatu dan sandal trendy', 'Assets/sepatupink.jpeg'),
('Aksesoris', 'Tas, topi, dan aksesoris fashion', 'Assets/Taspink.jpeg'),
('Olahraga', 'Perlengkapan olahraga dan outdoor', 'Assets/rakethitam.jpeg'),
('Jam Tangan', 'Jam tangan stylish untuk setiap gaya', 'Assets/jamtanganhitam.jpeg'),
('Drinkware', 'Tumbler dan botol minum', 'Assets/tumblerbiru.jpeg');

-- =============================================
-- SEED DATA - Products
-- =============================================
INSERT INTO products (category_id, name, description, price, stock, image_url, is_active) VALUES
-- Pakaian (1)
(1, 'Kaos Dream Hitam', 'Kaos katun premium dengan desain dream print, nyaman untuk aktivitas sehari-hari.', 85000, 50, 'Assets/kaosdreamhitam.jpeg', 1),
(1, 'Kaos Dream Biru', 'Kaos katun lembut dengan desain dream print warna biru yang stylish.', 85000, 45, 'Assets/kaosdreambiru.jpeg', 1),
(1, 'Kaos Dream Original', 'Kaos dream original dengan kualitas terbaik dan desain eksklusif.', 89000, 60, 'Assets/kaosdream.jpeg', 1),
(1, 'Kaos Hijau Premium', 'Kaos hijau dengan bahan katun combed berkualitas tinggi.', 75000, 70, 'Assets/kaoshijau.jpeg', 1),
(1, 'Kaos Hitam Basic', 'Kaos hitam polos basic yang cocok untuk gaya kasual.', 65000, 100, 'Assets/kaoshitam.jpeg', 1),
(1, 'Kaos Coklat Muda', 'Kaos warna coklat muda dengan fit nyaman untuk daily wear.', 70000, 55, 'Assets/kaosckltmuda.jpeg', 1),
(1, 'Kaos Kaki Biru', 'Kaos kaki premium dengan bahan lembut dan tahan lama.', 25000, 120, 'Assets/kaoskakibiru.jpeg', 1),
(1, 'Kaos Kaki Kuning', 'Kaos kaki kuning cerah dengan kualitas jahitan rapi.', 25000, 110, 'Assets/kaoskakikuning.jpeg', 1),
(1, 'Kaos Kaki Merah', 'Kaos kaki merah dengan bahan breathable dan nyaman.', 25000, 100, 'Assets/kaoskakimerah.jpeg', 1),
(1, 'Kaos Kaki Pink', 'Kaos kaki pink dengan desain modern dan trendy.', 25000, 90, 'Assets/kaoskakipink.jpeg', 1),
(1, 'Celana Abu-abu', 'Celana casual abu-abu dengan model slim fit yang stylish.', 150000, 40, 'Assets/celanaabuabu.jpg', 1),
(1, 'Celana Coklat', 'Celana panjang coklat dengan bahan premium dan nyaman.', 145000, 35, 'Assets/celanacoklat.jpg', 1),
(1, 'Celana Pink', 'Celana casual pink dengan cutting modern dan trendy.', 155000, 30, 'Assets/celanapink.jpg', 1),
(1, 'Jaket Coklat', 'Jaket coklat stylish dengan bahan berkualitas dan desain kekinian.', 250000, 25, 'Assets/jaketcoklat.jpeg', 1),
(1, 'Jaket Hitam', 'Jaket hitam dengan model modern cocok untuk segala suasana.', 245000, 30, 'Assets/jakethitam.jpeg', 1),
(1, 'Jaket Pink', 'Jaket pink trendy dengan bahan hangat dan nyaman.', 260000, 20, 'Assets/jaketpink.jpeg', 1),
(1, 'Sweater Abu-abu', 'Sweater abu-abu hangat dengan desain minimalis dan elegan.', 175000, 35, 'Assets/switerabuabu.jpeg', 1),
(1, 'Sweater Hitam', 'Sweater hitam dengan bahan lembut cocok untuk cuaca dingin.', 170000, 40, 'Assets/switerhitam.jpeg', 1),
(1, 'Sweater Putih', 'Sweater putih clean dengan desain simple dan stylish.', 180000, 38, 'Assets/switerputih.jpeg', 1),

-- Sepatu & Sandal (2)
(2, 'Sepatu Hijau Sport', 'Sepatu olahraga hijau dengan sol empuk dan desain sporty.', 320000, 28, 'Assets/sepatuhijau.jpeg', 1),
(2, 'Sepatu Kuning Casual', 'Sepatu casual kuning cerah yang trendy dan nyaman untuk jalan-jalan.', 295000, 32, 'Assets/sepatukuning.jpeg', 1),
(2, 'Sepatu Pink Fashion', 'Sepatu pink stylish dengan desain modern dan comfortable.', 310000, 25, 'Assets/sepatupink.jpeg', 1),
(2, 'Sandal Abu-abu', 'Sandal casual abu-abu dengan sol empuk dan tali kuat.', 85000, 60, 'Assets/sandalabuabu.jpeg', 1),
(2, 'Sandal Hitam', 'Sandal hitam simple dengan desain ergonomis dan nyaman.', 80000, 70, 'Assets/sandalhitam.jpeg', 1),
(2, 'Sandal Putih', 'Sandal putih clean dengan bahan berkualitas tinggi.', 90000, 55, 'Assets/sandalputih.jpeg', 1),
(2, 'Lakers Kuning', 'Sepatu lakers kuning iconic dengan desain klasik dan trendy.', 450000, 18, 'Assets/lakerskubing.jpeg', 1),
(2, 'Lakers Putih', 'Sepatu lakers putih premium dengan kualitas original.', 445000, 20, 'Assets/lakersputih.jpeg', 1),
(2, 'Lakers Ungu', 'Sepatu lakers ungu limited edition dengan desain eksklusif.', 460000, 15, 'Assets/lakersungu.jpeg', 1),

-- Aksesoris (3)
(3, 'Tas Hijau Fashion', 'Tas hijau trendy dengan banyak kompartemen dan bahan berkualitas.', 185000, 35, 'Assets/Tashijau.jpeg', 1),
(3, 'Tas Pink Stylish', 'Tas pink dengan desain modern dan praktis untuk daily use.', 195000, 30, 'Assets/Taspink.jpeg', 1),
(3, 'Tas Ungu Elegant', 'Tas ungu dengan model elegan cocok untuk berbagai acara.', 190000, 28, 'Assets/Tasungu.jpeg', 1),
(3, 'Tas Just Do It Biru', 'Tas sport biru dengan logo just do it dan desain sporty.', 165000, 45, 'Assets/tasjusdoitbiru.jpeg', 1),
(3, 'Tas Just Do It Hitam', 'Tas hitam dengan branding just do it yang iconic.', 160000, 50, 'Assets/tasjusdoithitam.jpeg', 1),
(3, 'Tas Just Do It Pink', 'Tas pink dengan logo just do it yang trendy dan eye-catching.', 170000, 40, 'Assets/tasjusdoitpink.jpeg', 1),
(3, 'Topi Biru', 'Topi casual biru dengan desain simple dan nyaman dipakai.', 55000, 80, 'Assets/topibiru.jpeg', 1),
(3, 'Topi Biru Putih', 'Topi kombinasi biru putih dengan desain sporty dan trendy.', 60000, 70, 'Assets/topibiruputih.jpeg', 1),
(3, 'Topi Hitam', 'Topi hitam klasik yang cocok untuk segala outfit.', 50000, 90, 'Assets/topihitam.jpeg', 1),
(3, 'Topi Merah', 'Topi merah cerah dengan bahan berkualitas dan tahan lama.', 58000, 65, 'Assets/topimerah.jpeg', 1),
(3, 'Topi Pink', 'Topi pink stylish dengan desain modern dan comfortable.', 57000, 75, 'Assets/topipink.jpeg', 1),

-- Olahraga (4)
(4, 'Raket Hijau Pro', 'Raket badminton hijau dengan material ringan dan kuat.', 285000, 22, 'Assets/rakethijau.jpeg', 1),
(4, 'Raket Hitam Premium', 'Raket hitam premium dengan teknologi terkini dan performa maksimal.', 295000, 20, 'Assets/rakethitam.jpeg', 1),
(4, 'Raket Merah Sport', 'Raket merah dengan desain aerodinamis untuk smash kuat.', 280000, 25, 'Assets/raketmerah.jpeg', 1),
(4, 'Raket Putih Elite', 'Raket putih elite dengan balance sempurna untuk pemain profesional.', 290000, 18, 'Assets/raketputih.jpeg', 1),

-- Jam Tangan (5)
(5, 'Jam Tangan Hitam Classic', 'Jam tangan hitam dengan desain klasik dan elegan untuk formal maupun casual.', 550000, 15, 'Assets/jamtanganhitam.jpeg', 1),
(5, 'Jam Tangan Pink Trendy', 'Jam tangan pink dengan desain modern dan stylish untuk wanita.', 520000, 18, 'Assets/jamtanganpink.jpeg', 1),
(5, 'Jam Tangan Putih Elegant', 'Jam tangan putih dengan desain minimalis dan elegan.', 540000, 12, 'Assets/jamtanganputih.jpeg', 1),

-- Drinkware (6)
(6, 'Tumbler Biru', 'Tumbler biru dengan kapasitas 500ml, menjaga minuman tetap dingin/panas.', 95000, 60, 'Assets/tumblerbiru.jpeg', 1),
(6, 'Tumbler Hijau', 'Tumbler hijau dengan desain ergonomis dan anti bocor.', 90000, 65, 'Assets/tumblerhijau.jpeg', 1),
(6, 'Tumbler Hitam', 'Tumbler hitam dengan material stainless steel berkualitas tinggi.', 100000, 55, 'Assets/tumblerhitam.jpeg', 1),
(6, 'Tumbler Pink', 'Tumbler pink dengan desain trendy dan mudah dibawa kemana-mana.', 92000, 70, 'Assets/tumblerpink.jpeg', 1);

-- =============================================
-- SEED DATA - Sample Orders
-- =============================================
INSERT INTO orders (user_id, customer_name, customer_email, customer_phone, shipping_address, total_amount, status) VALUES
(3, 'John Doe', 'user@example.com', '+1234567892', 'Jl. Sudirman No. 123, Jakarta Pusat, DKI Jakarta 10110', 805000, 'delivered'),
(4, 'Jane Smith', 'jane.smith@example.com', '+1234567893', 'Jl. Gatot Subroto No. 456, Bandung, Jawa Barat 40262', 445000, 'shipped'),
(3, 'John Doe', 'user@example.com', '+1234567892', 'Jl. Sudirman No. 123, Jakarta Pusat, DKI Jakarta 10110', 170000, 'pending');

-- =============================================
-- SEED DATA - Sample Order Items
-- =============================================
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
-- Order 1
(1, 1, 2, 85000),
(1, 14, 1, 250000),
(1, 20, 1, 320000),
(1, 47, 1, 95000),

-- Order 2
(2, 20, 1, 320000),
(2, 30, 1, 185000),
(2, 49, 2, 90000),

-- Order 3
(3, 1, 2, 85000);

-- =============================================
-- VERIFICATION QUERIES
-- =============================================
-- Verify the import
SELECT 'Users' as Table_Name, COUNT(*) as Record_Count FROM users
UNION ALL
SELECT 'Categories', COUNT(*) FROM categories
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'Order Items', COUNT(*) FROM order_items;

-- Show test accounts
SELECT 
    id,
    email,
    full_name,
    role,
    is_active
FROM users
ORDER BY role DESC, id;
