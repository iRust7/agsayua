# E-Commerce Database Documentation

## Overview
This document provides comprehensive information about the e-commerce database schema, including table structures, relationships, and usage guidelines.

**Database Name:** `ecommerce_db`  
**Version:** 1.0  
**Created:** January 2026  
**Character Set:** utf8mb4  
**Collation:** utf8mb4_unicode_ci

---

## Quick Start

### Import the Complete Database

```bash
# Option 1: Import using MySQL command line
mysql -u root -p < complete_import.sql

# Option 2: Import using MySQL command line with specific database
mysql -u root -p ecommerce_db < complete_import.sql

# Option 3: Using source command in MySQL shell
mysql -u root -p
source /path/to/complete_import.sql
```

### Separate Import (Schema + Seed Data)

```bash
# Import schema only
mysql -u root -p < schema.sql

# Then import seed data
mysql -u root -p < seed.sql
```

---

## Test Accounts

### Admin Accounts

| Email | Password | Role | Name |
|-------|----------|------|------|
| admin@ecommerce.com | Password123! | admin | Admin User |
| superadmin@ecommerce.com | Password123! | admin | Super Admin |

### User Accounts

| Email | Password | Role | Name |
|-------|----------|------|------|
| user@example.com | Password123! | user | John Doe |
| jane.smith@example.com | Password123! | user | Jane Smith |
| testuser@ecommerce.com | Password123! | user | Test User |

> **⚠️ Security Warning:** These are test credentials. In production:
> - Use strong, unique passwords
> - Implement proper bcrypt hashing with high cost factor (12+)
> - Enable two-factor authentication
> - Implement account lockout policies

---

## Database Schema

### Entity Relationship Diagram (ERD)

```
users (1) ─────< (N) orders
  │                     │
  │                     │
  │                     └─────< (N) order_items >───── (1) products
  │                                                          │
  └─────< (N) cart_items >──────────────────────────────────┘
                                                             │
                                                             │
                                                        categories (1)
```

---

## Table Definitions

### 1. users

**Description:** Stores customer and admin user accounts for authentication and authorization.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | Unique user identifier |
| email | VARCHAR(255) | NOT NULL, UNIQUE | User email address (login) |
| password_hash | VARCHAR(255) | NOT NULL | Bcrypt hashed password |
| full_name | VARCHAR(100) | NOT NULL | User's full name |
| phone | VARCHAR(20) | NULL | Contact phone number |
| role | ENUM('user', 'admin') | DEFAULT 'user' | User role for permissions |
| is_active | TINYINT(1) | DEFAULT 1 | Account status (1=active, 0=disabled) |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Account creation time |
| updated_at | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Last update time |
| last_login | TIMESTAMP | NULL | Last successful login |

**Indexes:**
- `idx_email` on email
- `idx_role` on role
- `idx_active` on is_active

---

### 2. categories

**Description:** Product categories for organizing the catalog.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | Category identifier |
| name | VARCHAR(100) | NOT NULL, UNIQUE | Category name |
| description | TEXT | NULL | Category description |
| image_url | VARCHAR(500) | NULL | Category banner/icon URL |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Last update time |

**Indexes:**
- `idx_name` on name

**Sample Data:**
- Electronics
- Fashion
- Home & Living
- Sports & Outdoors
- Books & Media
- Beauty & Health
- Toys & Games

---

### 3. products

**Description:** Product catalog with inventory management.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | Product identifier |
| category_id | INT | NOT NULL, FOREIGN KEY | Links to categories table |
| name | VARCHAR(255) | NOT NULL | Product name |
| description | TEXT | NULL | Detailed product description |
| price | DECIMAL(10, 2) | NOT NULL | Product price |
| stock | INT | NOT NULL, DEFAULT 0 | Available inventory quantity |
| image_url | VARCHAR(500) | NULL | Product image URL |
| is_active | TINYINT(1) | DEFAULT 1 | Product visibility (1=active, 0=hidden) |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |
| updated_at | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Last update time |

**Indexes:**
- `idx_category` on category_id
- `idx_active` on is_active
- `idx_price` on price
- `idx_name` on name
- `idx_created` on created_at

**Foreign Keys:**
- `category_id` REFERENCES `categories(id)` ON DELETE RESTRICT

---

### 4. orders

**Description:** Customer orders with delivery information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | Order identifier |
| user_id | INT | NULL, FOREIGN KEY | Links to users table (NULL for guest orders) |
| customer_name | VARCHAR(100) | NOT NULL | Customer's name |
| customer_email | VARCHAR(255) | NOT NULL | Customer's email |
| customer_phone | VARCHAR(20) | NOT NULL | Customer's phone |
| shipping_address | TEXT | NULL | Full delivery address |
| total_amount | DECIMAL(10, 2) | NOT NULL | Order total amount |
| status | ENUM | DEFAULT 'pending' | Order status (see below) |
| notes | TEXT | NULL | Order notes/instructions |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Order creation time |
| updated_at | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Last update time |

**Order Status Values:**
- `pending` - Order received, awaiting processing
- `processing` - Order is being prepared
- `shipped` - Order has been dispatched
- `delivered` - Order successfully delivered
- `cancelled` - Order was cancelled

**Indexes:**
- `idx_user` on user_id
- `idx_email` on customer_email
- `idx_status` on status
- `idx_created` on created_at

**Foreign Keys:**
- `user_id` REFERENCES `users(id)` ON DELETE SET NULL

---

### 5. order_items

**Description:** Line items for each order (many-to-many relationship between orders and products).

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | Order item identifier |
| order_id | INT | NOT NULL, FOREIGN KEY | Links to orders table |
| product_id | INT | NOT NULL, FOREIGN KEY | Links to products table |
| quantity | INT | NOT NULL | Quantity ordered |
| price | DECIMAL(10, 2) | NOT NULL | Price snapshot at time of order |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |

**Indexes:**
- `idx_order` on order_id
- `idx_product` on product_id

**Foreign Keys:**
- `order_id` REFERENCES `orders(id)` ON DELETE CASCADE
- `product_id` REFERENCES `products(id)` ON DELETE RESTRICT

---

### 6. cart_items

**Description:** Shopping cart items for authenticated users.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | Cart item identifier |
| user_id | INT | NOT NULL, FOREIGN KEY | Links to users table |
| product_id | INT | NOT NULL, FOREIGN KEY | Links to products table |
| quantity | INT | NOT NULL, DEFAULT 1 | Quantity in cart |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Added to cart time |
| updated_at | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Last update time |

**Indexes:**
- `idx_user` on user_id
- `idx_product` on product_id
- `unique_user_product` unique constraint on (user_id, product_id)

**Foreign Keys:**
- `user_id` REFERENCES `users(id)` ON DELETE CASCADE
- `product_id` REFERENCES `products(id)` ON DELETE CASCADE

---

## Common Queries

### Get all active products with category info

```sql
SELECT 
    p.*,
    c.name as category_name
FROM products p
INNER JOIN categories c ON p.category_id = c.id
WHERE p.is_active = 1
ORDER BY p.created_at DESC;
```

### Get order details with items

```sql
SELECT 
    o.*,
    oi.product_id,
    oi.quantity,
    oi.price,
    p.name as product_name
FROM orders o
INNER JOIN order_items oi ON o.id = oi.order_id
INNER JOIN products p ON oi.product_id = p.id
WHERE o.id = 1;
```

### Get user's cart with product details

```sql
SELECT 
    c.id as cart_item_id,
    c.quantity,
    p.id as product_id,
    p.name,
    p.price,
    p.stock,
    p.image_url,
    (c.quantity * p.price) as line_total
FROM cart_items c
INNER JOIN products p ON c.product_id = p.id
WHERE c.user_id = 1 AND p.is_active = 1;
```

### Get sales statistics by category

```sql
SELECT 
    c.name as category,
    COUNT(DISTINCT o.id) as total_orders,
    SUM(oi.quantity) as total_items_sold,
    SUM(oi.quantity * oi.price) as total_revenue
FROM categories c
INNER JOIN products p ON c.id = p.category_id
INNER JOIN order_items oi ON p.id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.id
WHERE o.status != 'cancelled'
GROUP BY c.id, c.name
ORDER BY total_revenue DESC;
```

---

## Backup and Restore

### Create Backup

```bash
# Full database backup
mysqldump -u root -p ecommerce_db > backup_$(date +%Y%m%d).sql

# Schema only
mysqldump -u root -p --no-data ecommerce_db > schema_backup.sql

# Data only
mysqldump -u root -p --no-create-info ecommerce_db > data_backup.sql
```

### Restore from Backup

```bash
mysql -u root -p ecommerce_db < backup_20260103.sql
```

---

## Maintenance

### Update Product Stock After Order

```sql
-- Decrease stock when order is placed
UPDATE products p
INNER JOIN order_items oi ON p.id = oi.product_id
SET p.stock = p.stock - oi.quantity
WHERE oi.order_id = ?;
```

### Clean Up Old Guest Cart Items

```sql
-- Delete cart items older than 30 days for non-registered users
DELETE FROM cart_items 
WHERE created_at < DATE_SUB(NOW(), INTERVAL 30 DAY)
AND user_id NOT IN (SELECT id FROM users WHERE is_active = 1);
```

### Archive Completed Orders

```sql
-- Move delivered orders older than 1 year to archive table
-- (Create archive_orders table first with same structure)
INSERT INTO archive_orders 
SELECT * FROM orders 
WHERE status = 'delivered' 
AND created_at < DATE_SUB(NOW(), INTERVAL 1 YEAR);

DELETE FROM orders 
WHERE status = 'delivered' 
AND created_at < DATE_SUB(NOW(), INTERVAL 1 YEAR);
```

---

## Performance Optimization

### Recommended Indexes

All necessary indexes are already created in the schema. Monitor slow query log for additional optimization needs.

### Table Optimization

```sql
-- Optimize all tables
OPTIMIZE TABLE users, categories, products, orders, order_items, cart_items;

-- Analyze tables for query optimization
ANALYZE TABLE users, categories, products, orders, order_items, cart_items;
```

---

## Security Best Practices

1. **Password Hashing:** Use bcrypt with cost factor 12 or higher
2. **Input Validation:** Always validate and sanitize user inputs
3. **Prepared Statements:** Use parameterized queries to prevent SQL injection
4. **Least Privilege:** Create separate database users with minimal required permissions
5. **Regular Backups:** Implement automated daily backups
6. **SSL/TLS:** Use encrypted connections to database
7. **Audit Logging:** Log all administrative actions

---

## Database User Setup

```sql
-- Create read-only user for reports
CREATE USER 'ecommerce_readonly'@'localhost' IDENTIFIED BY 'secure_password';
GRANT SELECT ON ecommerce_db.* TO 'ecommerce_readonly'@'localhost';

-- Create application user with limited permissions
CREATE USER 'ecommerce_app'@'localhost' IDENTIFIED BY 'secure_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON ecommerce_db.* TO 'ecommerce_app'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;
```

---

## Changelog

### Version 1.0 (January 2026)
- Initial database schema
- Core tables: users, categories, products, orders, order_items, cart_items
- Sample seed data with test accounts
- Comprehensive indexes and foreign keys
- Support for guest and authenticated orders

---

## Support

For questions or issues related to the database schema, please refer to:
- Schema file: `schema.sql`
- Seed data: `seed.sql`
- Complete import: `complete_import.sql`
- Backend API documentation: `../API_DOCUMENTATION.md`
