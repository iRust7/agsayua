package handlers

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

// GetAllOrders returns all orders for admin
func (h *Handler) GetAllOrders(w http.ResponseWriter, r *http.Request) {
	status := r.URL.Query().Get("status")

	query := `
		SELECT o.id, o.user_id, u.full_name, u.email, o.total_amount, o.status, o.created_at
		FROM orders o
		JOIN users u ON o.user_id = u.id
	`
	args := []interface{}{}

	if status != "" {
		query += " WHERE o.status = ?"
		args = append(args, status)
	}

	query += " ORDER BY o.created_at DESC"

	rows, err := h.DB.Query(query, args...)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to fetch orders")
		return
	}
	defer rows.Close()

	var orders []map[string]interface{}
	for rows.Next() {
		var (
			id, userID      int
			fullName, email string
			totalAmount     float64
			orderStatus     string
			createdAt       string
		)

		err := rows.Scan(&id, &userID, &fullName, &email, &totalAmount, &orderStatus, &createdAt)
		if err != nil {
			continue
		}

		orders = append(orders, map[string]interface{}{
			"id":           id,
			"user_id":      userID,
			"customer":     fullName,
			"email":        email,
			"total_amount": totalAmount,
			"status":       orderStatus,
			"created_at":   createdAt,
		})
	}

	respondSuccess(w, orders)
}

// GetOrderDetails returns detailed information about an order
func (h *Handler) GetOrderDetails(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		respondError(w, http.StatusBadRequest, "Invalid order ID")
		return
	}

	// Get order info
	var (
		userID      int
		fullName    string
		email       string
		totalAmount float64
		status      string
		createdAt   string
	)

	err = h.DB.QueryRow(`
		SELECT o.user_id, u.full_name, u.email, o.total_amount, o.status, o.created_at
		FROM orders o
		JOIN users u ON o.user_id = u.id
		WHERE o.id = ?
	`, id).Scan(&userID, &fullName, &email, &totalAmount, &status, &createdAt)

	if err != nil {
		respondError(w, http.StatusNotFound, "Order not found")
		return
	}

	// Get order items
	rows, err := h.DB.Query(`
		SELECT oi.product_id, p.name, oi.quantity, oi.price
		FROM order_items oi
		JOIN products p ON oi.product_id = p.id
		WHERE oi.order_id = ?
	`, id)

	if err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to fetch order items")
		return
	}
	defer rows.Close()

	var items []map[string]interface{}
	for rows.Next() {
		var (
			productID int
			name      string
			quantity  int
			price     float64
		)

		rows.Scan(&productID, &name, &quantity, &price)
		items = append(items, map[string]interface{}{
			"product_id": productID,
			"name":       name,
			"quantity":   quantity,
			"price":      price,
		})
	}

	respondSuccess(w, map[string]interface{}{
		"id":           id,
		"user_id":      userID,
		"customer":     fullName,
		"email":        email,
		"total_amount": totalAmount,
		"status":       status,
		"created_at":   createdAt,
		"items":        items,
	})
}

// UpdateOrderStatus updates the status of an order
func (h *Handler) UpdateOrderStatus(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		respondError(w, http.StatusBadRequest, "Invalid order ID")
		return
	}

	var req struct {
		Status string `json:"status"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	validStatuses := map[string]bool{
		"pending":    true,
		"processing": true,
		"completed":  true,
		"cancelled":  true,
	}

	if !validStatuses[req.Status] {
		respondError(w, http.StatusBadRequest, "Invalid status")
		return
	}

	_, err = h.DB.Exec("UPDATE orders SET status = ? WHERE id = ?", req.Status, id)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to update order status")
		return
	}

	respondSuccess(w, map[string]interface{}{
		"id":     id,
		"status": req.Status,
	})
}

// GetDashboardStats returns statistics for the admin dashboard
func (h *Handler) GetDashboardStats(w http.ResponseWriter, r *http.Request) {
	var stats struct {
		TotalProducts  int     `json:"total_products"`
		TotalOrders    int     `json:"total_orders"`
		TotalCustomers int     `json:"total_customers"`
		TotalRevenue   float64 `json:"total_revenue"`
	}

	h.DB.QueryRow("SELECT COUNT(*) FROM products").Scan(&stats.TotalProducts)
	h.DB.QueryRow("SELECT COUNT(*) FROM orders").Scan(&stats.TotalOrders)
	h.DB.QueryRow("SELECT COUNT(*) FROM users WHERE role = 'user'").Scan(&stats.TotalCustomers)
	h.DB.QueryRow("SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status = 'completed'").Scan(&stats.TotalRevenue)

	respondSuccess(w, stats)
}
