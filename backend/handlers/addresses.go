package handlers

import (
	"encoding/json"
	"net/http"
	"strconv"
	"strings"

	"github.com/gorilla/mux"
)

type Address struct {
	ID             int    `json:"id"`
	UserID         int    `json:"user_id"`
	Label          string `json:"label"`
	RecipientName  string `json:"recipient_name"`
	Phone          string `json:"phone"`
	Street         string `json:"street"`
	City           string `json:"city"`
	State          string `json:"state"`
	PostalCode     string `json:"postal_code"`
	IsDefault      bool   `json:"is_default"`
	CreatedAt      string `json:"created_at"`
}

func (h *Handler) GetAddresses(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	userID := vars["userId"]

	rows, err := h.DB.Query(
		`SELECT id, user_id, label, recipient_name, phone, street, city, state, postal_code, is_default, created_at
		 FROM addresses
		 WHERE user_id = ?
		 ORDER BY is_default DESC, created_at DESC`,
		userID,
	)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Gagal mengambil alamat")
		return
	}
	defer rows.Close()

	var addresses []Address
	for rows.Next() {
		var a Address
		var isDefault int
		if err := rows.Scan(&a.ID, &a.UserID, &a.Label, &a.RecipientName, &a.Phone, &a.Street, &a.City, &a.State, &a.PostalCode, &isDefault, &a.CreatedAt); err != nil {
			respondError(w, http.StatusInternalServerError, "Gagal membaca data alamat")
			return
		}
		a.IsDefault = isDefault == 1
		addresses = append(addresses, a)
	}

	respondSuccess(w, addresses)
}

func (h *Handler) CreateAddress(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	userID := vars["userId"]

	var req Address
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "Body tidak valid")
		return
	}

	req.UserID, _ = strconv.Atoi(userID)
	if strings.TrimSpace(req.Street) == "" || strings.TrimSpace(req.City) == "" {
		respondError(w, http.StatusBadRequest, "Alamat tidak lengkap")
		return
	}

	tx, err := h.DB.Begin()
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Gagal memulai transaksi")
		return
	}
	defer tx.Rollback()

	if req.IsDefault {
		if _, err := tx.Exec("UPDATE addresses SET is_default = 0 WHERE user_id = ?", userID); err != nil {
			respondError(w, http.StatusInternalServerError, "Gagal mengatur alamat default")
			return
		}
	}

	result, err := tx.Exec(
		`INSERT INTO addresses (user_id, label, recipient_name, phone, street, city, state, postal_code, is_default)
		 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
		req.UserID, req.Label, req.RecipientName, req.Phone, req.Street, req.City, req.State, req.PostalCode, boolToInt(req.IsDefault),
	)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Gagal menyimpan alamat")
		return
	}

	id, _ := result.LastInsertId()
	req.ID = int(id)

	if err := tx.Commit(); err != nil {
		respondError(w, http.StatusInternalServerError, "Gagal menyimpan alamat")
		return
	}

	respondJSON(w, http.StatusCreated, Response{
		Success: true,
		Data:    req,
		Message: "Alamat berhasil ditambahkan",
	})
}

func boolToInt(v bool) int {
	if v {
		return 1
	}
	return 0
}
