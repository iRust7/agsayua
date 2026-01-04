package handlers

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

type Product struct {
	ID          int     `json:"id"`
	CategoryID  int     `json:"category_id"`
	Name        string  `json:"name"`
	Description string  `json:"description"`
	Price       float64 `json:"price"`
	Stock       int     `json:"stock"`
	ImageURL    string  `json:"image_url"`
	CreatedAt   string  `json:"created_at"`
}

func (h *Handler) GetProducts(w http.ResponseWriter, r *http.Request) {
	search := r.URL.Query().Get("search")
	minPrice := r.URL.Query().Get("min_price")
	maxPrice := r.URL.Query().Get("max_price")

	query := "SELECT id, category_id, name, description, price, stock, image_url, created_at FROM products WHERE 1=1"
	var args []interface{}

	if search != "" {
		query += " AND (name LIKE ? OR description LIKE ?)"
		searchPattern := "%" + search + "%"
		args = append(args, searchPattern, searchPattern)
	}

	if minPrice != "" {
		query += " AND price >= ?"
		args = append(args, minPrice)
	}

	if maxPrice != "" {
		query += " AND price <= ?"
		args = append(args, maxPrice)
	}

	query += " ORDER BY name"

	rows, err := h.DB.Query(query, args...)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to fetch products")
		return
	}
	defer rows.Close()

	var products []Product
	for rows.Next() {
		var p Product
		if err := rows.Scan(&p.ID, &p.CategoryID, &p.Name, &p.Description, &p.Price, &p.Stock, &p.ImageURL, &p.CreatedAt); err != nil {
			respondError(w, http.StatusInternalServerError, "Failed to scan product")
			return
		}
		products = append(products, p)
	}

	respondSuccess(w, products)
}

func (h *Handler) GetProductByID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id := vars["id"]

	var p Product
	err := h.DB.QueryRow(
		"SELECT id, category_id, name, description, price, stock, image_url, created_at FROM products WHERE id = ?",
		id,
	).Scan(&p.ID, &p.CategoryID, &p.Name, &p.Description, &p.Price, &p.Stock, &p.ImageURL, &p.CreatedAt)

	if err != nil {
		respondError(w, http.StatusNotFound, "Product not found")
		return
	}

	respondSuccess(w, p)
}

func (h *Handler) GetProductsByCategory(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	categoryID := vars["categoryId"]

	rows, err := h.DB.Query(
		"SELECT id, category_id, name, description, price, stock, image_url, created_at FROM products WHERE category_id = ? ORDER BY name",
		categoryID,
	)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to fetch products")
		return
	}
	defer rows.Close()

	var products []Product
	for rows.Next() {
		var p Product
		if err := rows.Scan(&p.ID, &p.CategoryID, &p.Name, &p.Description, &p.Price, &p.Stock, &p.ImageURL, &p.CreatedAt); err != nil {
			respondError(w, http.StatusInternalServerError, "Failed to scan product")
			return
		}
		products = append(products, p)
	}

	respondSuccess(w, products)
}

func (h *Handler) CreateProduct(w http.ResponseWriter, r *http.Request) {
	var p Product
	if err := json.NewDecoder(r.Body).Decode(&p); err != nil {
		respondError(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	result, err := h.DB.Exec(
		"INSERT INTO products (category_id, name, description, price, stock, image_url) VALUES (?, ?, ?, ?, ?, ?)",
		p.CategoryID, p.Name, p.Description, p.Price, p.Stock, p.ImageURL,
	)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to create product")
		return
	}

	id, _ := result.LastInsertId()
	p.ID = int(id)

	respondJSON(w, http.StatusCreated, Response{
		Success: true,
		Data:    p,
		Message: "Product created successfully",
	})
}

func (h *Handler) UpdateProduct(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id := vars["id"]

	var p Product
	if err := json.NewDecoder(r.Body).Decode(&p); err != nil {
		respondError(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	_, err := h.DB.Exec(
		"UPDATE products SET category_id = ?, name = ?, description = ?, price = ?, stock = ?, image_url = ? WHERE id = ?",
		p.CategoryID, p.Name, p.Description, p.Price, p.Stock, p.ImageURL, id,
	)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to update product")
		return
	}

	idInt, _ := strconv.Atoi(id)
	p.ID = idInt

	respondJSON(w, http.StatusOK, Response{
		Success: true,
		Data:    p,
		Message: "Product updated successfully",
	})
}

func (h *Handler) DeleteProduct(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id := vars["id"]

	_, err := h.DB.Exec("DELETE FROM products WHERE id = ?", id)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to delete product")
		return
	}

	respondJSON(w, http.StatusOK, Response{
		Success: true,
		Message: "Product deleted successfully",
	})
}
