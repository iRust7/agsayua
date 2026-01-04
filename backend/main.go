package main

import (
	"database/sql"
	"log"
	"net/http"
	"os"

	"guaagsay/backend/handlers"

	_ "github.com/go-sql-driver/mysql"
	"github.com/gorilla/mux"
	"github.com/rs/cors"
)

func main() {
	// Initialize database
	var err error
	dsn := getEnv("DB_DSN", "root:@tcp(localhost:3306)/ecommerce_db?parseTime=true")
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}
	defer db.Close()

	// Test connection
	if err = db.Ping(); err != nil {
		log.Fatal("Failed to ping database:", err)
	}
	log.Println("Database connected successfully")

	// Setup router
	r := mux.NewRouter()
	h := handlers.NewHandler(db)

	// API routes
	api := r.PathPrefix("/api").Subrouter()

	// Auth
	api.HandleFunc("/auth/login", h.Login).Methods("POST")
	api.HandleFunc("/auth/register", h.Register).Methods("POST")
	api.HandleFunc("/auth/reset-password", h.ResetPassword).Methods("POST")

	// Categories
	api.HandleFunc("/categories", h.GetCategories).Methods("GET")
	api.HandleFunc("/categories/{id}", h.GetCategoryByID).Methods("GET")

	// Products
	api.HandleFunc("/products", h.GetProducts).Methods("GET")
	api.HandleFunc("/products/{id}", h.GetProductByID).Methods("GET")
	api.HandleFunc("/products/category/{categoryId}", h.GetProductsByCategory).Methods("GET")
	api.HandleFunc("/products", h.CreateProduct).Methods("POST")
	api.HandleFunc("/products/{id}", h.UpdateProduct).Methods("PUT")
	api.HandleFunc("/products/{id}", h.DeleteProduct).Methods("DELETE")

	// Orders
	api.HandleFunc("/orders", h.CreateOrder).Methods("POST")
	api.HandleFunc("/orders/{id}", h.GetOrderByID).Methods("GET")
	api.HandleFunc("/orders", h.GetOrders).Methods("GET")
	api.HandleFunc("/orders/{id}/status", h.UpdateOrderStatus).Methods("PUT")

	// User scoped routes
	userRoutes := api.PathPrefix("/users/{userId}").Subrouter()
	userRoutes.HandleFunc("/addresses", h.GetAddresses).Methods("GET")
	userRoutes.HandleFunc("/addresses", h.CreateAddress).Methods("POST")
	userRoutes.HandleFunc("/notifications", h.GetNotifications).Methods("GET")
	userRoutes.HandleFunc("/notifications/{notificationId}/read", h.MarkNotificationRead).Methods("PUT")

	// CORS
	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"*"},
		AllowCredentials: true,
	})

	handler := c.Handler(r)

	// Start server - bind to all interfaces for network access
	port := getEnv("PORT", "8080")
	address := "0.0.0.0:" + port
	log.Printf("Server starting on %s...", address)
	log.Fatal(http.ListenAndServe(address, handler))
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
