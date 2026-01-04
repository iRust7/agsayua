package handlers

import (
	"encoding/json"
	"net/http"

	"golang.org/x/crypto/bcrypt"
)

type User struct {
	ID       int    `json:"id"`
	Email    string `json:"email"`
	FullName string `json:"full_name"`
	Role     string `json:"role"`
}

type loginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type registerRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
	FullName string `json:"full_name"`
	Phone    string `json:"phone"`
}

type resetPasswordRequest struct {
	Email       string `json:"email"`
	NewPassword string `json:"new_password"`
}

// Login authenticates a user by email and password.
func (h *Handler) Login(w http.ResponseWriter, r *http.Request) {
	var req loginRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	var (
		id       int
		email    string
		fullName string
		hash     string
		role     string
		isActive int
	)

	err := h.DB.QueryRow(
		"SELECT id, email, full_name, password_hash, role, is_active FROM users WHERE email = ? LIMIT 1",
		req.Email,
	).Scan(&id, &email, &fullName, &hash, &role, &isActive)

	if err != nil {
		respondError(w, http.StatusUnauthorized, "Email atau password salah")
		return
	}

	if isActive == 0 {
		respondError(w, http.StatusForbidden, "Akun tidak aktif")
		return
	}

	if err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(req.Password)); err != nil {
		respondError(w, http.StatusUnauthorized, "Email atau password salah")
		return
	}

	respondSuccess(w, User{
		ID:       id,
		Email:    email,
		FullName: fullName,
		Role:     role,
	})
}

// Register creates a new user account.
func (h *Handler) Register(w http.ResponseWriter, r *http.Request) {
	var req registerRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "Invalid request body")
		return
	}

	if req.Email == "" || req.Password == "" || req.FullName == "" {
		respondError(w, http.StatusBadRequest, "Email, password, dan nama wajib diisi")
		return
	}

	hash, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Gagal membuat akun")
		return
	}

	result, err := h.DB.Exec(
		"INSERT INTO users (email, password_hash, full_name, phone, role, is_active) VALUES (?, ?, ?, ?, 'user', 1)",
		req.Email, string(hash), req.FullName, req.Phone,
	)
	if err != nil {
		respondError(w, http.StatusBadRequest, "Email sudah terdaftar")
		return
	}

	userID, _ := result.LastInsertId()
	respondJSON(w, http.StatusCreated, Response{
		Success: true,
		Message: "Akun berhasil dibuat",
		Data: User{
			ID:       int(userID),
			Email:    req.Email,
			FullName: req.FullName,
			Role:     "user",
		},
	})
}

// ResetPassword (debug) allows updating password directly.
func (h *Handler) ResetPassword(w http.ResponseWriter, r *http.Request) {
	var req resetPasswordRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		respondError(w, http.StatusBadRequest, "Invalid request body")
		return
	}
	if req.Email == "" || req.NewPassword == "" {
		respondError(w, http.StatusBadRequest, "Email dan password baru wajib diisi")
		return
	}

	hash, err := bcrypt.GenerateFromPassword([]byte(req.NewPassword), bcrypt.DefaultCost)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Gagal mengubah password")
		return
	}

	result, err := h.DB.Exec(
		"UPDATE users SET password_hash = ? WHERE email = ?",
		string(hash), req.Email,
	)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Gagal memperbarui password")
		return
	}
	affected, _ := result.RowsAffected()
	if affected == 0 {
		respondError(w, http.StatusNotFound, "User tidak ditemukan")
		return
	}

	respondSuccess(w, map[string]string{
		"email": req.Email,
		"msg":   "Password diperbarui (debug)",
	})
}
