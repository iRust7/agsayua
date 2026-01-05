package handlers

import (
	"encoding/json"
	"net/http"
	"strconv"
	"time"

	"github.com/gorilla/mux"
)

// AdminMiddleware checks if the user has admin role
func (h *Handler) AdminMiddleware(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// In a real app, you'd check JWT token or session
		// For now, we'll check a header
		role := r.Header.Get("X-User-Role")
		if role != "admin" {
			respondError(w, http.StatusForbidden, "Admin access required")
			return
		}
		next(w, r)
	}
}

// GetAllProducts returns all products for admin
func (h *Handler) GetAllProducts(w http.ResponseWriter, r *http.Request) {
	rows, err := h.DB.Query(`
		SELECT p.id, p.name, p.description, p.price, p.stock, p.image_url, 
		       c.id, c.name, p.created_at
		FROM products p
		LEFT JOIN categories c ON p.category_id = c.id
		ORDER BY p.created_at DESC
	`)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to fetch products")
		return
	}
	defer rows.Close()

	var products []map[string]interface{}
	for rows.Next() {
		var (
			id, stock, catID     int
			name, desc, imageURL string
			catName              string
			price                float64
			createdAt            time.Time
		)
		err := rows.Scan(&id, &name, &desc, &price, &stock, &imageURL, &catID, &catName, &createdAt)
		if err != nil {
			continue
		}

		products = append(products, map[string]interface{}{
			"id":          id,
			"name":        name,
			"description": desc,
			"price":       price,
			"stock":       stock,
			"image_url":   imageURL,
			"category": map[string]interface{}{
				"id":   catID,
				"name": catName,
			},
			"created_at": createdAt,
		})
	}

	respondSuccess(w, products)
}

// CreateProduct creates a new product
func (h *Handler) CreateProduct(w http.ResponseWriter, r *http.Request) {
	var req struct {
		Name        string  `json:"name"`
		Description string  `json:"description"`
		Price       float64 `json:"price"`
		CategoryID  int     `json:"category_id"`
		Stock       int     `json:"stock"`
		ImageURL    string  `json:"image_url"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	if req.Name == "" || req.Price <= 0 || req.CategoryID == 0 {
		respondError(w, http.StatusBadRequest, "Name, price, and category are required")
		return
	}

	result, err := h.DB.Exec(`
		INSERT INTO products (name, description, price, category_id, stock, image_url)
		VALUES (?, ?, ?, ?, ?, ?)
	`, req.Name, req.Description, req.Price, req.CategoryID, req.Stock, req.ImageURL)

	if err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to create product")
		return
	}

	id, _ := result.LastInsertId()
	respondJSON(w, http.StatusCreated, Response{
		Success: true,
		Message: "Product created successfully",
		Data: map[string]interface{}{
			"id":          id,
			"name":        req.Name,
			"description": req.Description,
			"price":       req.Price,
			"category_id": req.CategoryID,
			"stock":       req.Stock,
			"image_url":   req.ImageURL,
		},
	})
}

// UpdateProduct updates an existing product
func (h *Handler) UpdateProduct(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		respondError(w, http.StatusBadRequest, "Invalid product ID")
		return
	}

	var req struct {
		Name        string  `json:"name"`
		Description string  `json:"description"`
		Price       float64 `json:"price"`
		CategoryID  int     `json:"category_id"`
		Stock       int     `json:"stock"`
		ImageURL    string  `json:"image_url"`
	}

	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	_, err = h.DB.Exec(`
		UPDATE products 
		SET name = ?, description = ?, price = ?, category_id = ?, stock = ?, image_url = ?
		WHERE id = ?
	`, req.Name, req.Description, req.Price, req.CategoryID, req.Stock, req.ImageURL, id)

	if err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to update product")
		return
	}

	respondSuccess(w, map[string]interface{}{
		"id":          id,
		"name":        req.Name,
		"description": req.Description,
		"price":       req.Price,
		"category_id": req.CategoryID,
		"stock":       req.Stock,
		"image_url":   req.ImageURL,
	})
}

// DeleteProduct deletes a product
func (h *Handler) DeleteProduct(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		respondError(w, http.StatusBadRequest, "Invalid product ID")
		return
	}

	_, err = h.DB.Exec("DELETE FROM products WHERE id = ?", id)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to delete product")
		return
	}

	respondSuccess(w, map[string]string{"message": "Product deleted successfully"})
}
