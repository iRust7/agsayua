package handlers

import (
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

type Notification struct {
	ID        int    `json:"id"`
	UserID    int    `json:"user_id"`
	Title     string `json:"title"`
	Body      string `json:"body"`
	Type      string `json:"type"`
	IsRead    bool   `json:"is_read"`
	CreatedAt string `json:"created_at"`
}

func (h *Handler) GetNotifications(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	userID := vars["userId"]

	rows, err := h.DB.Query(
		`SELECT id, user_id, title, body, type, is_read, created_at
		 FROM notifications
		 WHERE user_id = ?
		 ORDER BY created_at DESC`,
		userID,
	)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Gagal mengambil notifikasi")
		return
	}
	defer rows.Close()

	var notifications []Notification
	for rows.Next() {
		var n Notification
		var isRead int
		if err := rows.Scan(&n.ID, &n.UserID, &n.Title, &n.Body, &n.Type, &isRead, &n.CreatedAt); err != nil {
			respondError(w, http.StatusInternalServerError, "Gagal membaca notifikasi")
			return
		}
		n.IsRead = isRead == 1
		notifications = append(notifications, n)
	}

	respondSuccess(w, notifications)
}

func (h *Handler) MarkNotificationRead(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	userID := vars["userId"]
	notificationID := vars["notificationId"]

	_, err := h.DB.Exec(
		"UPDATE notifications SET is_read = 1 WHERE id = ? AND user_id = ?",
		notificationID, userID,
	)
	if err != nil {
		respondError(w, http.StatusInternalServerError, "Gagal memperbarui notifikasi")
		return
	}

	idInt, _ := strconv.Atoi(notificationID)
	respondSuccess(w, map[string]interface{}{
		"id":      idInt,
		"is_read": true,
	})
}
