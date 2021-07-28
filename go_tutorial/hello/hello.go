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
    message, err := greetings.Hello("Oli")
    if err != nil {
        log.Fatal(err)
    }
    fmt.Println(message)
}