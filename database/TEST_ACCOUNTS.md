# Test Accounts Reference

Quick reference for testing the e-commerce application.

---

## 🔐 Admin Accounts

### Primary Admin
- **Email:** `admin@ecommerce.com`
- **Password:** `Password123!`
- **Role:** Admin
- **Name:** Admin User
- **Phone:** +1234567890

**Permissions:**
- Full access to admin panel
- Manage products, categories, orders
- View all users and analytics
- Modify system settings

### Super Admin
- **Email:** `superadmin@ecommerce.com`
- **Password:** `Password123!`
- **Role:** Admin
- **Name:** Super Admin
- **Phone:** +1234567891

**Permissions:**
- All admin permissions
- User management
- System configuration

---

## 👤 Regular User Accounts

### Test User 1 - John Doe
- **Email:** `user@example.com`
- **Password:** `Password123!`
- **Role:** User
- **Name:** John Doe
- **Phone:** +1234567892

**Usage:**
- Testing customer shopping flow
- Has existing orders in system
- Use for order history testing

### Test User 2 - Jane Smith
- **Email:** `jane.smith@example.com`
- **Password:** `Password123!`
- **Role:** User
- **Name:** Jane Smith
- **Phone:** +1234567893

**Usage:**
- Testing multiple user scenarios
- Has shipped orders
- Use for testing order tracking

### Test User 3 - Test Account
- **Email:** `testuser@ecommerce.com`
- **Password:** `Password123!`
- **Role:** User
- **Name:** Test User
- **Phone:** +1234567894

**Usage:**
- General testing
- Fresh account with no order history
- Use for new user flows

---

## 🧪 Test Scenarios

### Testing User Registration
1. Use a new email address (not in list above)
2. Password should meet requirements (8+ chars, uppercase, number, special char)
3. Verify email confirmation (if implemented)

### Testing Login
1. Use any account from above
2. Test wrong password handling
3. Test account lockout (if implemented)
4. Test "Remember Me" functionality

### Testing Shopping Flow
**As Regular User:**
1. Login as `user@example.com`
2. Browse products by category
3. Add items to cart
4. Proceed to checkout
5. Complete order with test payment info

**As Guest:**
1. Browse products without login
2. Add items to cart
3. Checkout as guest with email

### Testing Admin Features
**As Admin:**
1. Login as `admin@ecommerce.com`
2. View all orders
3. Update order status
4. Add new product
5. Modify existing product
6. View analytics/reports

---

## 🔒 Security Notes

> **⚠️ IMPORTANT:** These credentials are for development/testing only!

### For Production:
1. **Delete all test accounts**
2. **Change all passwords**
3. **Use environment variables** for admin credentials
4. **Implement proper bcrypt hashing** (cost 12+)
5. **Enable two-factor authentication**
6. **Set up account lockout policies**
7. **Monitor for suspicious activity**
8. **Regular security audits**

---

## 📊 Sample Data Overview

The database includes sample data for testing:

- **5 Users** (2 admins, 3 regular users)
- **7 Categories** (Electronics, Fashion, etc.)
- **30+ Products** across all categories
- **3 Sample Orders** with different statuses
- **Order Items** for realistic testing

---

## 🔄 Reset Test Data

To reset all test data to initial state:

```bash
# Re-import the complete database
mysql -u root -p < complete_import.sql
```

This will:
- Drop and recreate the database
- Restore all tables to initial state
- Reset all test accounts to default passwords
- Restore sample products and categories

---

## 🐛 Troubleshooting

### Can't Login?
1. Verify database is imported correctly
2. Check password is exactly: `Password123!`
3. Ensure backend is running
4. Check API endpoint configuration

### Account Locked?
1. Check database for `is_active` field
2. Run: `UPDATE users SET is_active = 1 WHERE email = 'user@example.com';`
3. Clear any login attempt counters (if implemented)

### Orders Not Showing?
1. Verify you're logged in as correct user
2. Check user_id in orders table matches logged-in user
3. Verify order status is not 'cancelled'

---

## 📝 API Testing with Test Accounts

### Login Request Example

```bash
# Login as admin
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@ecommerce.com",
    "password": "Password123!"
  }'
```

### Get User Orders

```bash
# Get orders for logged-in user (with JWT token)
curl -X GET http://localhost:8080/api/orders \
  -H "Authorization: Bearer <your_jwt_token>"
```

### Create Order as Guest

```bash
curl -X POST http://localhost:8080/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "customer_name": "Guest User",
    "customer_email": "guest@example.com",
    "customer_phone": "+1234567890",
    "items": [
      {
        "product_id": 1,
        "quantity": 2
      }
    ]
  }'
```

---

## 🎯 Testing Checklist

### User Features
- [ ] Register new account
- [ ] Login with existing account
- [ ] Browse products
- [ ] Search products
- [ ] Filter by category
- [ ] Add to cart
- [ ] Update cart quantities
- [ ] Remove from cart
- [ ] Checkout as guest
- [ ] Checkout as logged-in user
- [ ] View order history
- [ ] View order details

### Admin Features
- [ ] Login as admin
- [ ] View all orders
- [ ] Update order status
- [ ] View all users
- [ ] Add new product
- [ ] Edit product
- [ ] Delete product
- [ ] Add new category
- [ ] View analytics
- [ ] Export reports

---

## 📧 Contact Test Emails

All test account emails are functional patterns:
- `admin@ecommerce.com` - Admin account
- `user@example.com` - Regular user
- `testuser@ecommerce.com` - Test account

For email testing in development, consider:
- Using Mailtrap, MailHog, or similar services
- Setting up local SMTP server
- Logging emails to console instead of sending

---

**Last Updated:** January 3, 2026  
**Database Version:** 1.0
