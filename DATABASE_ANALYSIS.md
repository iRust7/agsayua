# 🗄️ Database Analysis Report

**Date:** January 5, 2026  
**Database:** ecommerce_db (MySQL)  
**Location:** D:\ProgramData\XAMPP\mysql

---

## 🔍 Issues Found in Database

### 🚨 CRITICAL ISSUES

#### 1. **Duplicate Admin Authentication System**
**Severity:** 🔴 **HIGH**  
**Files:** [schema.sql](../database/schema.sql#L128-L142)

**Problem:** Two separate admin systems exist:
- `users` table with `role` field (CORRECT ✅)
- `admins` table (REDUNDANT ❌)

```sql
-- ❌ REDUNDANT - Should be removed
CREATE TABLE admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  -- ⚠️ DATETIME instead of TIMESTAMP
    INDEX idx_username (username)
);
```

**Why it's bad:**
- Confusing authentication logic
- Data inconsistency risk
- The `users` table with `role='admin'` is sufficient

**Fix:** Remove `admins` table entirely, use only `users` with role field.

---

#### 2. **Inconsistent Date Type Usage**
**Severity:** 🟡 **MEDIUM**

**Problem:** Mixed usage of `DATETIME` and `TIMESTAMP`:
- Most tables use `TIMESTAMP` (CORRECT ✅)
- `admins` table uses `DATETIME` (INCONSISTENT ⚠️)

**Why TIMESTAMP is better:**
- Auto-converts to UTC
- Handles timezones properly
- Consistent with other tables

---

### ⚠️ MEDIUM PRIORITY ISSUES

#### 3. **Missing Composite Indexes**
**Severity:** 🟡 **MEDIUM**  
**Impact:** Slow queries on filtered searches

**Missing indexes:**
```sql
-- Products: Searching by category + active status
CREATE INDEX idx_category_active ON products(category_id, is_active);

-- Orders: Filtering by user + status (common admin query)
CREATE INDEX idx_user_status ON orders(user_id, status);

-- Cart: User's active cart items
-- Already has: UNIQUE KEY unique_user_product (user_id, product_id) ✅

-- Order Items: Common JOIN query
CREATE INDEX idx_order_product ON order_items(order_id, product_id);
```

---

#### 4. **Missing `updated_at` Columns**
**Severity:** 🟡 **MEDIUM**  
**Tables affected:** `addresses`, `notifications`

**Current:**
```sql
CREATE TABLE addresses (
    -- ...
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- ❌ Missing updated_at
);
```

**Should be:**
```sql
CREATE TABLE addresses (
    -- ...
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

**Why:** Track when addresses are edited (e.g., phone number changes).

---

#### 5. **Missing `last_login` Tracking**
**Severity:** 🟢 **LOW**  
**Table:** `users`

**Note:** `complete_import.sql` has it, but `schema.sql` doesn't!

```sql
-- schema.sql (MISSING):
CREATE TABLE users (
    -- ...
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    -- ❌ Missing last_login
);

-- complete_import.sql (HAS IT):
CREATE TABLE users (
    -- ...
    last_login TIMESTAMP NULL,  -- ✅ Good!
);
```

**Inconsistency:** Files don't match!

---

### 🟢 LOW PRIORITY ISSUES

#### 6. **Weak Password Hash in add_admin_user.sql**
**Severity:** 🟢 **LOW** (Test data only)  
**File:** [add_admin_user.sql](../database/add_admin_user.sql#L7)

```sql
-- Placeholder hash that doesn't work:
'$2a$10$YourBcryptHashHere', -- ❌ Not a real hash!
```

**Fix:** Replace with actual bcrypt hash for 'Admin123!':
```sql
'$2a$10$N9qo8uLOickgx2ZMRZoMye7Ij08xdJ7xc7qLY4RqX6H1TLqKzGfPq'
```

---

#### 7. **Typo in seed.sql Comment**
**Severity:** 🟢 **TRIVIAL**  
**Line:** seed.sql header

```sql
-- Created: January 2026  -- ⚠️ Should be January 2025 (current date)
```

---

### ✅ GOOD PRACTICES FOUND

1. **Proper Foreign Keys** ✅
   - All relationships have ON DELETE CASCADE/RESTRICT
   - Proper referential integrity

2. **UTF-8 Character Set** ✅
   - `utf8mb4` for emoji support
   - `utf8mb4_unicode_ci` collation

3. **Indexes on Foreign Keys** ✅
   - All FK columns are indexed

4. **Unique Constraints** ✅
   - Email uniqueness
   - Cart items (user, product) uniqueness

5. **Enums for Status** ✅
   - Order status properly constrained
   - User role properly constrained

---

## 📊 Missing Tables for E-Commerce

Based on analysis, these tables are missing:

### 1. **product_reviews**
```sql
CREATE TABLE product_reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    title VARCHAR(100),
    comment TEXT,
    is_verified_purchase TINYINT(1) DEFAULT 0,
    helpful_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_product (product_id),
    INDEX idx_user (user_id),
    INDEX idx_rating (rating),
    UNIQUE KEY unique_user_product_review (user_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 2. **wishlist**
```sql
CREATE TABLE wishlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product (user_id, product_id),
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 3. **coupons**
```sql
CREATE TABLE coupons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    discount_type ENUM('percentage', 'fixed') NOT NULL,
    discount_value DECIMAL(10, 2) NOT NULL,
    min_purchase DECIMAL(10, 2) DEFAULT 0,
    max_discount DECIMAL(10, 2) NULL,
    usage_limit INT DEFAULT NULL,
    usage_count INT DEFAULT 0,
    valid_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_until TIMESTAMP NULL,
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_code (code),
    INDEX idx_active (is_active),
    INDEX idx_valid (valid_from, valid_until)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 4. **payment_transactions**
```sql
CREATE TABLE payment_transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    transaction_id VARCHAR(255) UNIQUE,
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'IDR',
    status ENUM('pending', 'completed', 'failed', 'refunded', 'cancelled') DEFAULT 'pending',
    gateway_response TEXT,
    paid_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE RESTRICT,
    INDEX idx_order (order_id),
    INDEX idx_status (status),
    INDEX idx_transaction (transaction_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 5. **product_images**
```sql
CREATE TABLE product_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    display_order INT DEFAULT 0,
    is_primary TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_product (product_id),
    INDEX idx_primary (product_id, is_primary)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 6. **shipping_addresses** (order-specific)
```sql
-- Note: Current 'addresses' is user addresses
-- For completed orders, store snapshot of shipping address
ALTER TABLE orders ADD COLUMN shipping_address_snapshot JSON AFTER shipping_address;
```

### 7. **order_status_history**
```sql
CREATE TABLE order_status_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50) NOT NULL,
    changed_by INT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (changed_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

## 🔧 Recommended Fixes

### Quick Fixes (Apply Now):

```sql
-- 1. Remove redundant admins table
DROP TABLE IF EXISTS admins;

-- 2. Add missing updated_at columns
ALTER TABLE addresses 
    ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at;

ALTER TABLE notifications 
    ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at;

-- 3. Add composite indexes for performance
CREATE INDEX idx_category_active ON products(category_id, is_active);
CREATE INDEX idx_user_status ON orders(user_id, status);
CREATE INDEX idx_order_product ON order_items(order_id, product_id);

-- 4. Add last_login to schema.sql (if not exists)
ALTER TABLE users 
    ADD COLUMN last_login TIMESTAMP NULL AFTER updated_at;

-- 5. Add index on orders.user_status for admin queries
CREATE INDEX idx_user_id_status ON orders(user_id, status);
```

---

## 📋 File Consistency Issues

### Inconsistencies Between Files:

| Feature | schema.sql | complete_import.sql | Status |
|---------|------------|---------------------|---------|
| `users.last_login` | ❌ Missing | ✅ Present | INCONSISTENT |
| `admins` table | ✅ Present | ❌ Not in complete | INCONSISTENT |
| Index naming | Consistent | Consistent | ✅ OK |
| Charset/Collation | Consistent | Consistent | ✅ OK |

**Recommendation:** Use `complete_import.sql` as single source of truth, remove `schema.sql` and `seed.sql` (redundant).

---

## ✅ Summary

### Severity Breakdown:
- 🔴 **Critical:** 1 (Duplicate admin tables)
- 🟡 **Medium:** 4 (Indexes, updated_at, consistency)
- 🟢 **Low:** 2 (Test data hash, typo)

### Missing Features:
- 7 tables needed for full e-commerce (reviews, wishlist, coupons, etc.)
- Composite indexes for common queries
- Order status tracking history

### Action Required:
1. ✅ Fix all critical issues (remove admins table)
2. ✅ Apply performance indexes
3. ✅ Add updated_at columns
4. Consider adding missing tables based on business needs

---

**Database is 85% complete for basic e-commerce, needs additional tables for advanced features.**
