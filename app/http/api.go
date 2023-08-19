package http

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/labstack/echo/v4"
)

const (
	ctxTimeout = 10
)

type Server struct {
	echo *echo.Echo
}

func NewServer() *Server {
	return &Server{
		echo: echo.New(),
	}
}

type Log struct {
	Pat     time.Time `json:"pat"`
	ID      string    `json:"id"`
	LogType string    `json:"log_type"`
}

func (s *Server) Run() error {
	if err := s.SetHandlers(s.echo); err != nil {
		return err
	}

	server := &http.Server{
		Addr:    ":8080",
		Handler: s.echo,
	}

	go func() {
		if err := s.echo.StartServer(server); err != nil {
			fmt.Println("err ", err)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, os.Interrupt, syscall.SIGTERM)

	<-quit

	ctx, shutdown := context.WithTimeout(context.Background(), ctxTimeout*time.Second)
	defer shutdown()

	return s.echo.Server.Shutdown(ctx)
}

func (s *Server) SetHandlers(e *echo.Echo) error {
	v1 := e.Group("")
	health := v1.Group("/healthz")

	health.GET("", func(c echo.Context) error {
		log := Log{
			Pat:     time.Now(),
			ID:      time.Now().String(),
			LogType: "test",
		}
		j, err := json.Marshal(log)
		if err != nil {
		}
		fmt.Printf("%s\n", j)

		return c.String(http.StatusOK, "health check ok")
	})

	return nil
}
