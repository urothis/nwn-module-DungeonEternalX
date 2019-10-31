package main

import (
	"context"
	"fmt"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/client"
	"github.com/robfig/cron"
	log "github.com/sirupsen/logrus"
)

func dockerPull() error {
	cli, err := client.NewEnvClient()
	if err != nil {
		panic(err)
	}

	containers, err := cli.ContainerList(context.Background(), types.ContainerListOptions{})
	if err != nil {
		panic(err)
	}

	if len(containers) > 0 {
		for _, container := range containers {
			fmt.Printf("Container ID: %s", container.ID)
		}
	} else {
		fmt.Println("There are no containers running")
	}
	return nil
}

// InitDockerPull init cron
func InitDockerPull() {
	// cron things
	c := cron.New()
	c.AddFunc("@every 1s", func() { dockerPull() })
	log.WithFields(log.Fields{"automated docker pull initiated": 1}).Info("disdex")
	c.Start()
}
