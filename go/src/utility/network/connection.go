package network

import (
	"errors"
	"log"
	"net"
	"time"
)

const (
	xConnStatus_None = iota
	xConnStatus_Connected
	xConnStatus_Disconnected
)

const (
	xConnEvent_None = iota
	xConnEvent_Connected
	xConnEvent_Disconnected
	xConnEvent_Data
	xConnEvent_Close
	xConnEvent_Total
)

const (
	xConnConf_DefaultSendTimeoutSec = 5
	xConnConf_MaxReaBufferLength    = 0xffff
)

const (
	xConnFlag_CopySendBuffer = 1 << iota
)

type Connection struct {
	conn                net.Conn
	status              int
	connId              int
	sendMsgQueue        chan []byte
	sendTimeoutSec      int
	eventQueue          IEventQueue
	streamProtocol      IStreamProtocol
	maxReadBufferLength int
	userdata            interface{}
	from                int
	readTimeoutSec      int
}

func newConnection(c net.Conn, sendBufferSize int, eq IEventQueue) *Connection {
	return &Connection{
		conn:                c,
		status:              xConnStatus_None,
		connId:              0,
		sendMsgQueue:        make(chan []byte, sendBufferSize),
		sendTimeoutSec:      xConnConf_DefaultSendTimeoutSec,
		maxReadBufferLength: xConnConf_MaxReaBufferLength,
		eventQueue:          eq,
	}
}

type ConnEvent struct {
	EventType int
	Conn      *Connection
	Data      []byte
}

func newConnEvent(et int, c *Connection, d []byte) *ConnEvent {
	return &ConnEvent{
		EventType: et,
		Conn:      c,
		Data:      d,
	}
}

func (this *Connection) close() {
	if xConnStatus_Connected != this.status {
		return
	}

	this.conn.Close()
	this.status = xConnStatus_Disconnected
}

func (this *Connection) Close() {
	if xConnStatus_Connected != this.status {
		return
	}

	select {
	case this.sendMsgQueue <- nil:
		{
			// nothing
		}
	case <-time.After(time.Duration(this.sendTimeoutSec)):
		{
			this.close()
			log.Printf("Conn[%d] send message timeout, close conn", this.connId)
		}
	}
	this.status = xConnStatus_Disconnected
}

func (this *Connection) pushEvent(et int, d []byte) {
	if nil == this.eventQueue {
		log.Println("nil event queue")
		return
	}
	this.eventQueue.Push(newConnEvent(et, this, d))
}

func (this *Connection) GetStatus() int {
	return this.status
}

func (this *Connection) setStatus(stat int) {
	this.status = stat
}

func (this *Connection) GetConnId() int {
	return this.connId
}

func (this *Connection) SetConnId(id int) {
	this.connId = id
}

func (this *Connection) GetUserdata() interface{} {
	return this.userdata
}

func (this *Connection) SetUserdata(ud interface{}) {
	this.userdata = ud
}

func (this *Connection) SetReadTimeoutSec(sec int) {
	this.readTimeoutSec = sec
}

func (this *Connection) GetReadTimeoutSec() int {
	return this.readTimeoutSec
}

func (this *Connection) GetRemoteAddress() string {
	return this.conn.RemoteAddr().String()
}

func (this *Connection) setStreamProtocol(sp IStreamProtocol) {
	this.streamProtocol = sp
}

func (this *Connection) sendRaw(msg []byte) {
	if this.status != xConnStatus_Connected {
		return
	}

	select {
	case this.sendMsgQueue <- msg:
		{
			//	nothing
		}
	case <-time.After(time.Duration(this.sendTimeoutSec)):
		{
			//	timeout, close the connection
			this.close()
			log.Printf("Con[%d] send message timeout, close it", this.connId)
		}
	}
}

func (this *Connection) Send(msg []byte, flag int64) {
	if this.status != xConnStatus_Connected {
		return
	}

	buf := msg

	//	copy send buffer
	if 0 != flag&xConnFlag_CopySendBuffer {
		msgCopy := make([]byte, len(msg))
		copy(msgCopy, msg)
		buf = msgCopy
	}

	select {
	case this.sendMsgQueue <- buf:
		{
			//	nothing
		}
	case <-time.After(time.Duration(this.sendTimeoutSec)):
		{
			//	timeout, close the connection
			this.close()
			log.Printf("Con[%d] send message timeout, close it", this.connId)
		}
	}
}

//	run a routine to process the connection
func (this *Connection) run() {
	go this.routineMain()
}

func (this *Connection) routineMain() {
	defer func() {
		//	routine end
		log.Printf("Routine of connection[%d] quit", this.connId)
		e := recover()
		if e != nil {
			log.Println("Panic:", e)
		}

		//	close the connection
		this.close()

		//	free channel
		close(this.sendMsgQueue)
		this.sendMsgQueue = nil

		//	post event
		this.pushEvent(xConnEvent_Disconnected, nil)
	}()

	if nil == this.streamProtocol {
		log.Println("Nil stream protocol")
		return
	}
	this.streamProtocol.Init()

	//	connected
	this.pushEvent(xConnEvent_Connected, nil)
	this.status = xConnStatus_Connected

	go this.routineSend()
	this.routineRead()
}

func (this *Connection) routineSend() error {
	defer func() {
		log.Println("Connection", this.connId, " send loop return")
	}()

	for {
		select {
		case evt, ok := <-this.sendMsgQueue:
			{
				if !ok {
					//	channel closed, quit
					return nil
				}

				if nil == evt {
					log.Println("User disconnect")
					this.close()
					return nil
				}

				var err error

				headerBytes := this.streamProtocol.SerializeHeader(evt)
				if nil != headerBytes {
					//	write header first
					_, err = this.conn.Write(headerBytes)
					if err != nil {
						log.Println("Conn write error:", err)
						return err
					}
				} else {
					//	invalid packet
					log.Println("Failed to serialize header")
					break
				}

				_, err = this.conn.Write(evt)
				if err != nil {
					log.Println("Conn write error:", err)
					return err
				}
			}
		}
	}

	return nil
}

func (this *Connection) routineRead() error {
	//	default buffer
	buf := make([]byte, this.maxReadBufferLength)

	for {
		msg, err := this.unpack(buf)
		if err != nil {
			log.Println("Conn read error:", err)
			return err
		}

		if this.status == xConnStatus_Connected {
			//	only push event when the connection is connected
			this.pushEvent(xConnEvent_Data, msg)
		}
	}

	return nil
}

func (this *Connection) unpack(buf []byte) ([]byte, error) {
	//	read head
	if 0 != this.readTimeoutSec {
		this.conn.SetReadDeadline(time.Now().Add(time.Duration(this.readTimeoutSec) * time.Second))
	}
	headBuf := buf[:this.streamProtocol.GetHeaderLength()]
	_, err := this.conn.Read(headBuf)
	if err != nil {
		return nil, err
	}

	//	check length
	packetLength := this.streamProtocol.UnserializeHeader(headBuf)
	if packetLength > this.maxReadBufferLength ||
		0 == packetLength {
		return nil, errors.New("The stream data is too long")
	}

	//	read body
	if 0 != this.readTimeoutSec {
		this.conn.SetReadDeadline(time.Now().Add(time.Duration(this.readTimeoutSec) * time.Second))
	}
	bodyLength := packetLength - this.streamProtocol.GetHeaderLength()
	_, err = this.conn.Read(buf[:bodyLength])
	if err != nil {
		return nil, err
	}

	//	ok
	msg := make([]byte, bodyLength)
	copy(msg, buf[:bodyLength])
	if 0 != this.readTimeoutSec {
		this.conn.SetReadDeadline(time.Time{})
	}

	return msg, nil
}
