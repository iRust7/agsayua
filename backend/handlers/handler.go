package handlers

import (
	"database/sql"
	"encoding/json"
	"net/http"
)

// Handler groups shared dependencies for HTTP handlers.
type Handler struct {
	DB *sql.DB
}

// NewHandler creates a Handler with the provided DB connection.
func NewHandler(db *sql.DB) *Handler {
	return &Handler{DB: db}
}

type Response struct {
	Success bool        `json:"success"`
	Data    interface{} `json:"data,omitempty"`
	Message string      `json:"message,omitempty"`
	Error   string      `json:"error,omitempty"`
}

func respondJSON(w http.ResponseWriter, status int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(data)
}

func respondError(w http.ResponseWriter, status int, message string) {
	respondJSON(w, status, Response{
		Success: false,
		Error:   message,
	})
}

func respondSuccess(w http.ResponseWriter, data interface{}) {
	respondJSON(w, http.StatusOK, Response{
		Success: true,
		Data:    data,
	})
}
