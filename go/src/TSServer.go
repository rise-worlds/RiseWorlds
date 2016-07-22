package main

import (
	"log"

	"./utility/network"
)

type TSServer struct {
	network *network.TCPNetwork
}

func NewTSServer() *TSServer {
	t := &TSServer{}
	t.network = network.NewTCPNetwork(1024, network.NewStreamProtocol4())
	return t
}

func (this *TSServer) OnConnected(evt *network.ConnEvent) {
	log.Println("connected ", evt.Conn.GetConnId())
}

func (this *TSServer) OnDisconnected(evt *network.ConnEvent) {
	log.Println("disconnected ", evt.Conn.GetConnId())
}

func (this *TSServer) OnRecv(evt *network.ConnEvent) {
	log.Println("recv ", evt.Conn.GetConnId(), evt.Data)

	evt.Conn.Send(evt.Data, 0)
}

func (this *TSServer) Run() {
	err := this.network.Listen("127.0.0.1:2222")

	if err != nil {
		log.Println(err)
		return
	}

	this.network.ServeWithHandler(this)
	log.Println("done")
}
