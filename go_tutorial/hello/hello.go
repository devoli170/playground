package main

import (
    "fmt"

    "github.com/devoli170/playground/go_tutorial/greetings"
)

func main() {
    // Get a greeting message and print it.
    message := greetings.Hello("Gladys")
    fmt.Println(message)
}