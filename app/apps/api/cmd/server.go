package main

import (
	"fmt"

	"ecskinesislambda/http"
)

func main() {
	s := http.NewServer()
	if err := s.Run(); err != nil {
		fmt.Println("run fail")
	}
}
