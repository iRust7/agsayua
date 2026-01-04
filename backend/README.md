# E-commerce Backend (Go)

A RESTful API backend built with Go for the e-commerce application.

## Prerequisites

- Go 1.21 or higher
- MySQL 5.7 or higher

## Setup

1. Install dependencies:
```bash
go mod download
```

2. Configure database:
   - Copy `.env.example` to `.env`
   - Update the database connection string

3. Initialize the database:
   - Run the SQL scripts in the `database` folder

## Running

```bash
go run .
```

The server will start on port 8080 (or the port specified in .env).

## API Endpoints

### Categories
- `GET /api/categories` - Get all categories
- `GET /api/categories/{id}` - Get category by ID

### Products
- `GET /api/products` - Get all products (supports search, min_price, max_price query params)
- `GET /api/products/{id}` - Get product by ID
- `GET /api/products/category/{categoryId}` - Get products by category
- `POST /api/products` - Create product
- `PUT /api/products/{id}` - Update product
- `DELETE /api/products/{id}` - Delete product

### Orders
- `POST /api/orders` - Create order
- `GET /api/orders` - Get all orders (supports status query param)
- `GET /api/orders/{id}` - Get order by ID
- `PUT /api/orders/{id}/status` - Update order status

## Building

```bash
go build -o ecommerce-backend
```

## Production Deployment

For production, consider:
- Using environment variables for configuration
- Setting up proper logging
- Adding authentication/authorization
- Implementing rate limiting
- Using a production-grade web server
