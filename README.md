# E-Commerce Mobile App

A modern, clean, and professional e-commerce mobile application built with Flutter and PHP REST API, backed by MySQL database.

## 🎯 Project Overview

This is a complete e-commerce solution featuring:
- Modern UI/UX design with Material Design 3
- Product browsing and search
- Shopping cart management
- Order placement and tracking
- Admin panel for product and order management
- REST API with MySQL backend

## 📁 Project Structure

```
guaagsay/
├── backend/                    # PHP REST API
│   ├── api/                   # API endpoints
│   │   ├── categories.php
│   │   ├── products.php
│   │   └── orders.php
│   └── config/                # Configuration files
│       ├── database.php
│       └── cors.php
├── database/                  # Database scripts
│   ├── schema.sql            # Database schema
│   └── seed.sql              # Sample data
├── ecommerce_app/            # Flutter mobile app
│   └── lib/
│       ├── core/             # Core utilities
│       │   ├── network/      # API client
│       │   ├── theme/        # Design system
│       │   ├── utils/        # Utilities
│       │   └── widgets/      # Reusable widgets
│       ├── features/         # App features
│       │   ├── catalog/
│       │   ├── cart/
│       │   ├── orders/
│       │   └── admin/
│       └── main.dart
└── README.md
```

## 🚀 Getting Started

### Prerequisites

- **XAMPP** (or similar with PHP 7.4+ and MySQL 5.7+)
- **Flutter SDK** (3.0.0 or higher)
- **Android Studio** or **VS Code** with Flutter extensions
- **Android Emulator** or **Physical Device**

### Step 1: Database Setup

1. **Start XAMPP**
   - Open XAMPP Control Panel
   - Start **Apache** and **MySQL**

2. **Create Database**
   - Open phpMyAdmin: `http://localhost/phpmyadmin`
   - Create a new database named `ecom_app`

3. **Import Schema**
   ```sql
   -- In phpMyAdmin, select ecom_app database
   -- Go to Import tab
   -- Choose file: database/schema.sql
   -- Click Go
   ```

4. **Import Seed Data**
   ```sql
   -- Import file: database/seed.sql
   -- This will populate categories and products
   ```

### Step 2: Backend API Setup

1. **Copy Backend Files**
   ```bash
   # Copy the backend folder to XAMPP htdocs
   # Example path: C:\xampp\htdocs\ecommerce_api
   
   Copy-Item -Path "backend\*" -Destination "C:\xampp\htdocs\ecommerce_api\" -Recurse
   ```

2. **Configure Database Connection**
   - Open `backend/config/database.php`
   - Verify database credentials:
   ```php
   private $host = "localhost";
   private $db_name = "ecom_app";
   private $username = "root";
   private $password = "";
   ```

3. **Test API**
   - Open browser: `http://localhost/ecommerce_api/api/categories.php`
   - Should return JSON with categories

### Step 3: Flutter App Setup

1. **Navigate to Flutter Project**
   ```powershell
   cd ecommerce_app
   ```

2. **Install Dependencies**
   ```powershell
   flutter pub get
   ```

3. **Configure API Base URL**
   
   **For Android Emulator:**
   - Open `lib/core/network/api_client.dart`
   - Use: `http://10.0.2.2/ecommerce_api/api`
   
   **For iOS Simulator:**
   - Use: `http://localhost/ecommerce_api/api`
   
   **For Real Device:**
   - Find your computer's IP address:
     ```powershell
     ipconfig
     # Look for IPv4 Address under your network adapter
     # Example: 192.168.1.100
     ```
   - Use: `http://YOUR_IP/ecommerce_api/api`
   - Example: `http://192.168.1.100/ecommerce_api/api`

4. **Run the App**
   ```powershell
   # Check available devices
   flutter devices
   
   # Run on connected device/emulator
   flutter run
   
   # Or run with hot reload
   flutter run --debug
   ```

## 🎨 Features

### Customer Features
- ✅ Browse products by category
- ✅ Search products with filters
- ✅ View product details with images
- ✅ Add products to cart
- ✅ Adjust cart quantities
- ✅ Place orders with address
- ✅ Track order status
- ✅ View order history

### Admin Features
- ✅ Manage products (CRUD)
- ✅ Manage categories (CRUD)
- ✅ Update order status
- ✅ View all orders

## 🎯 Design System

### Color Palette
- **Primary:** Blue (#2563EB)
- **Accent:** Pink (#EC4899)
- **Success:** Green (#10B981)
- **Warning:** Amber (#F59E0B)
- **Error:** Red (#EF4444)

### Typography
- **Display:** 32px, Bold
- **H1:** 28px, Bold
- **H2:** 24px, Semibold
- **Body:** 14px, Regular
- **Caption:** 12px, Regular

### Spacing
- Base unit: 4px
- Screen padding: 16px
- Card padding: 16px
- Button height: 44px (min tap target)

## 📱 Screens

### Public Screens
1. Home (Product grid + Categories)
2. Search
3. Product Detail
4. Cart
5. Checkout
6. Orders List
7. Order Detail
8. Account

### Admin Screens
1. Product Management
2. Product Form
3. Category Management
4. Category Form
5. Order Management

## 🔧 API Endpoints

See [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for complete API reference.

### Base URL
```
http://localhost/ecommerce_api/api
```

### Quick Reference
- **Categories:** `/categories.php`
- **Products:** `/products.php`
- **Orders:** `/orders.php`

## 🐛 Troubleshooting

### Common Issues

**1. Cannot connect to API**
- Verify XAMPP Apache is running
- Check API URL in `api_client.dart`
- For emulator, use `10.0.2.2` instead of `localhost`
- For device, ensure phone and computer are on same network

**2. Database connection error**
- Verify MySQL is running in XAMPP
- Check database credentials in `config/database.php`
- Ensure database `ecom_app` exists

**3. CORS errors**
- Verify `config/cors.php` is included in API files
- Check browser console for specific CORS errors

**4. Flutter build errors**
- Run `flutter clean`
- Run `flutter pub get`
- Restart IDE

## 📝 Testing

### Test Accounts
- **Admin:** username: `admin`, password: `admin123`

### Sample Data
The seed file includes:
- 7 categories
- 25+ products
- Sample images from Unsplash

## 🚢 Deployment Notes

This project is configured for **local development**. For production:

1. **Backend:**
   - Use environment variables for sensitive data
   - Implement proper authentication (JWT)
   - Use prepared statements (already implemented)
   - Enable HTTPS
   - Set up proper CORS policy

2. **Mobile App:**
   - Update API base URL
   - Enable code obfuscation
   - Implement proper error tracking
   - Add analytics

## 📄 License

This project is for educational and demonstration purposes.

## 🤝 Contributing

This is a demonstration project. Feel free to fork and modify for your needs.

## 📧 Support

For issues or questions, refer to the inline documentation in the code.

---

**Built with ❤️ using Flutter and PHP**
