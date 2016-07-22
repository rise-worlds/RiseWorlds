package main

import (
	"log"

	"./utility/network"
)

type TSClient struct {
	network *network.TCPNetwork
}

func NewTSClient() *TSClient {
	t := &TSClient{}
	t.network = network.NewTCPNetwork(1024, network.NewStreamProtocol4())
	return t
}

func (this *TSClient) OnConnected(evt *network.ConnEvent) {
	log.Println("connected ", evt.Conn.GetConnId())
}

func (this *TSClient) OnDisconnected(evt *network.ConnEvent) {
	log.Println("disconnected ", evt.Conn.GetConnId())
}

func (this *TSClient) OnRecv(evt *network.ConnEvent) {
	log.Println("recv ", evt.Conn.GetConnId(), evt.Data)

	evt.Conn.Send(evt.Data, 0)
}

func (this *TSClient) Open() {
	conn, err := this.network.Connect("127.0.0.1:2222")

	if err != nil {
		log.Println(err)
		return
	}

	this.network.ServeWithHandler(this)
	log.Println("connected ", conn.GetConnId())
}
