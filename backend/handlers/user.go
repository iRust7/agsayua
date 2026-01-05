package handlers

import (
	"encoding/json"
	"log"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

type updateProfileRequest struct {
	FullName string `json:"full_name"`
	Phone    string `json:"phone"`
}

// UpdateProfile updates the user's profile information.
func (h *Handler) UpdateProfile(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	userIDStr := vars["userId"]
	userID, err := strconv.Atoi(userIDStr)
	if err != nil {
		respondError(w, http.StatusBadRequest, "Invalid user ID")
		return
	}

	var req updateProfileRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	if req.FullName == "" {
		respondError(w, http.StatusBadRequest, "Nama lengkap wajib diisi")
		return
	}

	// query to update user
	log.Printf("Updating user %d: %s, %s", userID, req.FullName, req.Phone)
	query := "UPDATE users SET full_name = ?, phone = ? WHERE id = ?"
	result, err := h.DB.Exec(query, req.FullName, req.Phone, userID)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Gagal memperbarui profil")
		return
	}

	rowsAffected, _ := result.RowsAffected()
	if rowsAffected == 0 {
		// Check if user exists
		var exists bool
		err := h.DB.QueryRow("SELECT EXISTS(SELECT 1 FROM users WHERE id = ?)", userID).Scan(&exists)
		if err != nil || !exists {
			respondError(w, http.StatusNotFound, "User tidak ditemukan")
			return
		}
		// If user exists but no changes were made, that's fine, just return success
	}

	// Fetch updated user to return
	var updatedUser User
	err = h.DB.QueryRow(
		"SELECT id, email, full_name, role FROM users WHERE id = ?",
		userID,
	).Scan(&updatedUser.ID, &updatedUser.Email, &updatedUser.FullName, &updatedUser.Role)

	if err != nil {
		respondError(w, http.StatusInternalServerError, "Gagal mengambil data user terbaru")
		return
	}

	respondSuccess(w, updatedUser)
}
