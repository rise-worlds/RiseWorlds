package main

import (
	"log"
)

func main() {
	//
	//Mandelbrot()

	err := Pinger("127.0.0.1", 10)
	if err != nil {
		log.Println(err)
	}

}
