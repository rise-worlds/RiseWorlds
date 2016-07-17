package main

import (
	"fmt"
	"log"

	"./utility/network"
)

type TSShutdown struct {
	network *network.TCPNetwork
}

func NewTSShutdown() *TSShutdown {
	t := &TSShutdown{}
	t.network = network.NewTCPNetwork(1024, network.NewStreamProtocol4())
	return t
}

func (this *TSShutdown) OnConnected(evt *network.ConnEvent) {
	log.Println("connected ", evt.Conn.GetConnId())
}

func (this *TSShutdown) OnDisconnected(evt *network.ConnEvent) {
	log.Println("disconnected ", evt.Conn.GetConnId())
}

func (this *TSShutdown) OnRecv(evt *network.ConnEvent) {
	log.Println("recv ", evt.Conn.GetConnId(), evt.Data)

	evt.Conn.Send(evt.Data, 0)
}

func (this *TSShutdown) Run() {
	err := this.network.Listen("127.0.0.1:2222")

	if err != nil {
		log.Println(err)
		return
	}

	this.network.ServeWithHandler(this)
	log.Println("done")
}

func main() {
	fmt.Print("hello world.")
	defer func() {
		e := recover()
		if e != nil {
			log.Println(e)
		}
		var inp int
		fmt.Scanln(&inp)
	}()
	tsshutdown := NewTSShutdown()
	tsshutdown.Run()
}
