# golang_select_demo

This repository is a sample for how select is for concurrency reading from multiple channels

## What is select

select is golang syntax that provide a mechanism that could concurrently received message from multiple channel

if not use select, that multiple channel received will become blocking I/O

## sample

### 1 blocking Read
```golang
package main

import (
	"log"
	"time"
)

func main() {
	chans := []chan int{
		make(chan int),
		make(chan int),
	}
	// use two go routines to send messages to channel concurrently
	for i := range chans {
		go func(i int, ch chan<- int) {
			for {
				time.Sleep(time.Duration(i) * time.Second)
				ch <- i
			}
		}(i+1, chans[i])
	}
	// receive message from channel alternative
	for i := 0; i < 12; i++ {
    m0 := <-chans[0] // this will be blocked until chans[0] could read
    log.Println("received", m0)
		m1 := <-chans[1] // this will be blocked until chans[1] could read
    log.Println("received", m1)
	}
}

```
### 2 concurrent read

select could switch between ready channels to read message
```golang
package main

import (
	"log"
	"time"
)

func main() {
	chans := []chan int{
		make(chan int),
		make(chan int),
	}
	// use two go routines to send messages to channel concurrently
	for i := range chans {
		go func(i int, ch chan<- int) {
			for {
				time.Sleep(time.Duration(i) * time.Second)
				ch <- i
			}
		}(i+1, chans[i])
	}
	// use select to concurrently receive message from channel
	for i := 0; i < 12; i++ {
		select {
		case m0 := <-chans[0]:
			log.Println("received", m0)
		case m1 := <-chans[1]:
			log.Println("received", m1)
		}
	}
}
```

## default

when there is no channel ready, default block is the logic running

```golang
func sendOrDrop(data []byte) {
  select {
    case ch <- data:
      // sent ok; do nothing
    default:
      log.Printf("overflow: drop %d bytes", len(data))
  }
}
```

Don't use **default** inside a loop -- the select will busy wait and waste CPU