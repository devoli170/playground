package main

import (
    "fmt"
    "log"

    "github.com/devoli170/playground/go_tutorial/greetings"
)

func main() {
    log.SetPrefix("greetings: ")
    log.SetFlags(0)
    // Get a greeting message and print it.

        // A slice of names.
    names := []string{"Gladys", "Samantha", "Darrin"}
    message, err := greetings.Hellos(names)
    if err != nil {
        log.Fatal(err)
    }
    fmt.Println(message)
}