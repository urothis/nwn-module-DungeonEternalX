package main

import (
    "os"
    "os/exec"
	"syscall"
	
	"github.com/robfig/cron"
	log "github.com/sirupsen/logrus"
)

func dockerCheck() {
    binary, lookErr := exec.LookPath("docker")
    if lookErr != nil {
        panic(lookErr)
	}	
	
	args := []string{"docker", "pull"}

	env := os.Environ()

    execErr := syscall.Exec(binary, args, env)
    if execErr != nil {
        panic(execErr)
	}

	log.WithFields(log.Fields{"docker pull": 1}).Info("disdex")

}

// InitDockerPull init cron 
func InitDockerPull() {
	// cron things
	c := cron.New()
	c.AddFunc("@every 1m", func() { dockerCheck() })
	log.WithFields(log.Fields{"automated docker pull initiated": 1}).Info("disdex")
	c.Start()
}