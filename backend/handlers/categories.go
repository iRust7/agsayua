package handlers

import (
	"net/http"

	"github.com/gorilla/mux"
)

type Category struct {
	ID          int    `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	ImageURL    string `json:"image_url"`
	CreatedAt   string `json:"created_at"`
}

func (h *Handler) GetCategories(w http.ResponseWriter, r *http.Request) {
	rows, err := h.DB.Query("SELECT id, name, description, image_url, created_at FROM categories ORDER BY name")
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Failed to fetch categories")
		return
	}
	defer rows.Close()

	var categories []Category
	for rows.Next() {
		var c Category
		if err := rows.Scan(&c.ID, &c.Name, &c.Description, &c.ImageURL, &c.CreatedAt); err != nil {
			respondError(w, http.StatusInternalServerError, "Failed to scan category")
			return
		}
		categories = append(categories, c)
	}

	respondSuccess(w, categories)
}

func (h *Handler) GetCategoryByID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id := vars["id"]

	var c Category
	err := h.DB.QueryRow(
		"SELECT id, name, description, image_url, created_at FROM categories WHERE id = ?",
		id,
	).Scan(&c.ID, &c.Name, &c.Description, &c.ImageURL, &c.CreatedAt)

	if err != nil {
		respondError(w, http.StatusNotFound, "Category not found")
		return
	}

	respondSuccess(w, c)
}
