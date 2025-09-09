package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

// Simple Hello World program in Go
func main() {
	fmt.Println("Hello, World!")
	fmt.Println("Welcome to Go!")

	// Get user input
	fmt.Print("What's your name? ")
	reader := bufio.NewReader(os.Stdin)
	name, _ := reader.ReadString('\n')
	name = strings.TrimSpace(name)
	fmt.Printf("Nice to meet you, %s!\n", name)
}
