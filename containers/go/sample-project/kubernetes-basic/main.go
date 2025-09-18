package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
)

// HealthResponse represents the health check response
type HealthResponse struct {
	Status    string    `json:"status"`
	Timestamp time.Time `json:"timestamp"`
	Version   string    `json:"version"`
	PodName   string    `json:"pod_name"`
}

// InfoResponse represents the info endpoint response
type InfoResponse struct {
	Message   string    `json:"message"`
	Timestamp time.Time `json:"timestamp"`
	Version   string    `json:"version"`
	PodName   string    `json:"pod_name"`
	Host      string    `json:"host"`
}

func main() {
	// Get environment variables
	version := getEnv("APP_VERSION", "1.0.0")
	port := getEnv("PORT", "8080")
	podName := getEnv("POD_NAME", "unknown")

	// Set Gin mode
	gin.SetMode(gin.ReleaseMode)
	r := gin.Default()

	// Add middleware for logging
	r.Use(gin.Logger())
	r.Use(gin.Recovery())

	// Health check endpoint
	r.GET("/health", func(c *gin.Context) {
		response := HealthResponse{
			Status:    "healthy",
			Timestamp: time.Now(),
			Version:   version,
			PodName:   podName,
		}
		c.JSON(http.StatusOK, response)
	})

	// Info endpoint
	r.GET("/info", func(c *gin.Context) {
		hostname, _ := os.Hostname()
		response := InfoResponse{
			Message:   "Hello from CleanStart Go Kubernetes Sample!",
			Timestamp: time.Now(),
			Version:   version,
			PodName:   podName,
			Host:      hostname,
		}
		c.JSON(http.StatusOK, response)
	})

	// Root endpoint
	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "Welcome to CleanStart Go Kubernetes Sample!",
			"version": version,
			"pod":     podName,
			"time":    time.Now(),
		})
	})

	// Readiness probe endpoint
	r.GET("/ready", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status": "ready",
		})
	})

	// Liveness probe endpoint
	r.GET("/live", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status": "alive",
		})
	})

	// Start server
	log.Printf("Starting CleanStart Go Kubernetes Sample on port %s", port)
	log.Printf("Pod Name: %s", podName)
	log.Printf("Version: %s", version)
	
	if err := r.Run(":" + port); err != nil {
		log.Fatal("Failed to start server:", err)
	}
}

// getEnv gets an environment variable or returns a default value
func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
