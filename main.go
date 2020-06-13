package main

import (
	"net/http"

	"drone-cache/bar"
	"drone-cache/foo"
)

func helloHandler(w http.ResponseWriter, req *http.Request) {
	w.Write([]byte("Hello World!"))
}

func fooHandler(w http.ResponseWriter, req *http.Request) {
	w.Write([]byte(foo.Foo()))
}

func barHandler(w http.ResponseWriter, req *http.Request) {
	w.Write([]byte(bar.Bar()))
}

func main() {
	r := http.NewServeMux()
	r.HandleFunc("/hello", helloHandler)
	r.HandleFunc("/foo", fooHandler)
	r.HandleFunc("/bar", barHandler)

	http.ListenAndServe(":8080", r)
}
