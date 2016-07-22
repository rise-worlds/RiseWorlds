package main

import "log"

func main() {
	// fmt.Print("hello world.")
	// defer func() {
	// 	e := recover()
	// 	if e != nil {
	// 		log.Println(e)
	// 	}
	// 	var inp int
	// 	fmt.Scanln(&inp)
	// }()

	TSClient := NewTSClient()
	TSClient.Open()

	TSServer := NewTSServer()
	TSServer.Run()

	log.Println("done")
}
