package main

import (
	"os"
	"os/signal"
	"syscall"

	log "github.com/sirupsen/logrus"
)

func checkENV() (err error) {
	//if os.Getenv("DISDEX_REDIS_HOST") == "" {
	//	log.WithFields(log.Fields{"DISDEX_REDIS_HOST": "nil"}).Fatal("disdex:core:env")
	//}
	//if os.Getenv("DISDEX_REDIS_PORT") == "" {
	//	log.WithFields(log.Fields{"DISDEX_REDIS_PORT": "nil"}).Fatal("disdex:core:env")
	//}
	if os.Getenv("DISDEX_DISCORD_KEY") == "" {
		log.WithFields(log.Fields{"DISDEX_DISCORD_KEY": "nil"}).Fatal("disdex:core:env")
	}
	return
}

func main() {
	// load the core config here
	err := checkENV()
	if err != nil {
		return
	}

	// Initialize
	log.WithFields(log.Fields{"Booted": 1}).Info("disdex")

	//go InitRedis()
	go initDiscord()

	// wait until signal received.
	done := make(chan os.Signal, 1)
	signal.Notify(done, syscall.SIGINT, syscall.SIGTERM, os.Interrupt, os.Kill)
	<-done
}
