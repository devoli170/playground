package main

import (
    "fmt"
    "net/http"
)

func h(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello World!")
}

func main() {
    http.HandleFunc("/", h)
    http.ListenAndServe("[::]:80", nil)
}