package handlers

import (
	"encoding/json"
	"net/http"

	"github.com/gorilla/mux"
)

type Order struct {
	ID            int         `json:"id"`
	CustomerName  string      `json:"customer_name"`
	CustomerEmail string      `json:"customer_email"`
	CustomerPhone string      `json:"customer_phone"`
	TotalAmount   float64     `json:"total_amount"`
	Status        string      `json:"status"`
	CreatedAt     string      `json:"created_at"`
	Items         []OrderItem `json:"items,omitempty"`
}

type OrderItem struct {
	ID        int     `json:"id"`
	OrderID   int     `json:"order_id"`
	ProductID int     `json:"product_id"`
	Quantity  int     `json:"quantity"`
	Price     float64 `json:"price"`
}

type CreateOrderRequest struct {
	CustomerName  string      `json:"customer_name"`
	CustomerEmail string      `json:"customer_email"`
	CustomerPhone string      `json:"customer_phone"`
	Items         []OrderItem `json:"items"`
}

func (h *Handler) CreateOrder(w http.ResponseWriter, r *http.Request) {
	var req CreateOrderRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	// Validate request
	if req.CustomerName == "" || req.CustomerEmail == "" || len(req.Items) == 0 {
		respondError(w, http.StatusBadRequest, "Missing required fields")
		return
	}

	// Calculate total amount
	var totalAmount float64
	for _, item := range req.Items {
		var price float64
		err := h.DB.QueryRow("SELECT price FROM products WHERE id = ?", item.ProductID).Scan(&price)
		if err != nil {
			respondError(w, http.StatusBadRequest, "Invalid product ID")
			return
		}
		totalAmount += price * float64(item.Quantity)
	}

	// Begin transaction
	tx, err := h.DB.Begin()
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to start transaction")
		return
	}
	defer tx.Rollback()

	// Insert order
	result, err := tx.Exec(
		"INSERT INTO orders (customer_name, customer_email, customer_phone, total_amount, status) VALUES (?, ?, ?, ?, ?)",
		req.CustomerName, req.CustomerEmail, req.CustomerPhone, totalAmount, "pending",
	)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to create order")
		return
	}

	orderID, _ := result.LastInsertId()

	// Insert order items
	for _, item := range req.Items {
		var price float64
		err := tx.QueryRow("SELECT price FROM products WHERE id = ?", item.ProductID).Scan(&price)
		if err != nil {
			respondError(w, http.StatusBadRequest, "Invalid product ID")
			return
		}

		_, err = tx.Exec(
			"INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)",
			orderID, item.ProductID, item.Quantity, price,
		)
		if err != nil {
			respondError(w, http.StatusInternalServerError, "Failed to create order item")
			return
		}

		// Update product stock
		_, err = tx.Exec(
			"UPDATE products SET stock = stock - ? WHERE id = ?",
			item.Quantity, item.ProductID,
		)
		if err != nil {
			respondError(w, http.StatusInternalServerError, "Failed to update stock")
			return
		}
	}

	// Commit transaction
	if err := tx.Commit(); err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to commit transaction")
		return
	}

	order := Order{
		ID:            int(orderID),
		CustomerName:  req.CustomerName,
		CustomerEmail: req.CustomerEmail,
		CustomerPhone: req.CustomerPhone,
		TotalAmount:   totalAmount,
		Status:        "pending",
	}

	respondJSON(w, http.StatusCreated, Response{
		Success: true,
		Data:    order,
		Message: "Order created successfully",
	})
}

func (h *Handler) GetOrderByID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id := vars["id"]

	var order Order
	err := h.DB.QueryRow(
		"SELECT id, customer_name, customer_email, customer_phone, total_amount, status, created_at FROM orders WHERE id = ?",
		id,
	).Scan(&order.ID, &order.CustomerName, &order.CustomerEmail, &order.CustomerPhone, &order.TotalAmount, &order.Status, &order.CreatedAt)

	if err != nil {
		respondError(w, http.StatusNotFound, "Order not found")
		return
	}

	// Get order items
	rows, err := h.DB.Query(
		"SELECT id, order_id, product_id, quantity, price FROM order_items WHERE order_id = ?",
		id,
	)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to fetch order items")
		return
	}
	defer rows.Close()

	var items []OrderItem
	for rows.Next() {
		var item OrderItem
		if err := rows.Scan(&item.ID, &item.OrderID, &item.ProductID, &item.Quantity, &item.Price); err != nil {
			respondError(w, http.StatusInternalServerError, "Failed to scan order item")
			return
		}
		items = append(items, item)
	}
	order.Items = items

	respondSuccess(w, order)
}

func (h *Handler) GetOrders(w http.ResponseWriter, r *http.Request) {
	status := r.URL.Query().Get("status")

	query := "SELECT id, customer_name, customer_email, customer_phone, total_amount, status, created_at FROM orders"
	var args []interface{}

	if status != "" {
		query += " WHERE status = ?"
		args = append(args, status)
	}

	query += " ORDER BY created_at DESC"

	rows, err := h.DB.Query(query, args...)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to fetch orders")
		return
	}
	defer rows.Close()

	var orders []Order
	for rows.Next() {
		var order Order
		if err := rows.Scan(&order.ID, &order.CustomerName, &order.CustomerEmail, &order.CustomerPhone, &order.TotalAmount, &order.Status, &order.CreatedAt); err != nil {
			respondError(w, http.StatusInternalServerError, "Failed to scan order")
			return
		}
		orders = append(orders, order)
	}

	respondSuccess(w, orders)
}

// Note: UpdateOrderStatus has been moved to admin_orders.go
// for proper admin access control. Use the admin endpoint for this operation.
