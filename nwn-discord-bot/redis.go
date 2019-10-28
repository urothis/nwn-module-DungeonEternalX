package main

import (
	"os"
	"time"

	"github.com/garyburd/redigo/redis"
	log "github.com/sirupsen/logrus"
)

var (
	// RedisPool is the active redis connection
	RedisPool *redis.Pool
)

func hsetRediskey(key string, field string, value string) {
	redisCon := RedisPool.Get()
	defer redisCon.Close()
	redisCon.Do("hset", key, field, value)
	return
}

func hgetRediskeyString(key string, field string) (string, error) {
	redisCon := RedisPool.Get()
	defer redisCon.Close()
	result, err := redis.String(redisCon.Do("hget", key, field))
	if err != nil {
		log.Warnln("failed to perform hget operation on redis", err)
	}
	return result, err
}

func hgetRediskeyInt(key string, field string) (int, error) {
	redisCon := RedisPool.Get()
	defer redisCon.Close()
	result, err := redis.Int(redisCon.Do("hget", key, field))
	if err != nil {
		log.Warnln("failed to perform hget operation on redis", err)
	}
	return result, err
}

func newPool(server string) *redis.Pool {
	return &redis.Pool{
		MaxIdle:     300,
		MaxActive:   600,
		IdleTimeout: 20000 * time.Second,
		Dial: func() (redis.Conn, error) {
			c, err := redis.Dial("tcp", server)
			if err != nil {
				return nil, err
			}
			return c, err
		},
		TestOnBorrow: func(c redis.Conn, t time.Time) error {
			_, err := c.Do("PING")
			return err
		},
	}
}

// InitRedis func
func InitRedis() {
	addr := "redis:" + os.Getenv("DISDEX_REDIS_PORT")
	RedisPool = newPool(addr)

	rps := redis.PubSubConn{Conn: RedisPool.Get()}
	rps.Subscribe(
		"discord.register",
		"discord.out",
	)

	for {
		switch msg := rps.Receive().(type) {
			case redis.Message:
				switch msg.Channel {
					case "discord.register":


						log.WithFields(log.Fields{"Pubsub": "1", "Channel": msg.Channel, "Message": msg.Data}).Info("disdex.pubsub")
					case "discord.out":
						var err error
						err = DiscordInHandler(string(msg.Data))
						if err != nil {
							log.WithFields(log.Fields{"Pubsub": "0", "Channel": msg.Channel, "Message": string(msg.Data)}).Info("disdex.pubsub")
						}
						log.WithFields(log.Fields{"Pubsub": "1", "Channel": msg.Channel, "Message": msg.Data}).Info("disdex.pubsub")
					case "log.fatal":
						log.WithFields(log.Fields{"Pubsub": "1", "Channel": msg.Channel, "Message": msg.Data}).Info("disdex.pubsub")
				}

			case redis.Subscription: {
				log.WithFields(log.Fields{"Channel": msg.Channel}).Info("disdex.redis.pubsub.subscribe")
			}
		}
	}
}

// SendPubsub func
func SendPubsub(PubsubChannel string, PubsubMessage string) {
	r := RedisPool.Get()
	r.Do("PUBLISH", PubsubChannel, PubsubMessage)

	if os.Getenv("DISDEX_REDIS_PUBSUB_VERBOSE") == "1" {
		log.WithFields(log.Fields{"Channel": PubsubChannel, "Message": PubsubMessage}).Info("disdex.redis.pubsub")
	}
}