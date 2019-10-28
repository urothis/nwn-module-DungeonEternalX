package main

import (
	"crypto/rand"
	"encoding/base64"
	"os"

	"github.com/bwmarrin/discordgo"
	log "github.com/sirupsen/logrus"
)

var (
	// Discord pointer so we can grab discord session
	Discord       *discordgo.Session
	commandPrefix string
	botID         string
	botKey        string
)

// GenerateRandomBytes func
func GenerateRandomBytes(n int) ([]byte, error) {
	b := make([]byte, n)
	_, err := rand.Read(b)
	// Note that err == nil only if we read len(b) bytes.
	if err != nil {
		return nil, err
	}

	return b, nil
}

// GenerateRandomString returns a URL-safe, base64 encoded
// securely generated random string.
func GenerateRandomString(s int) (string, error) {
	b, err := GenerateRandomBytes(s)
	return base64.URLEncoding.EncodeToString(b), err
}

func initDiscord() {
	var err error

	log.WithFields(log.Fields{"Connected": "1"}).Info("disdex.Discord")

	Discord, err = discordgo.New("Bot " + os.Getenv("DISDEX_DISCORD_BOT_KEY"))
	errCheck("error creating discord session", err)
	user, err := Discord.User("@me")
	errCheck("error retrieving account", err)

	botID = user.ID
	Discord.AddHandler(replyHandler)
	Discord.AddHandler(func(discord *discordgo.Session, ready *discordgo.Ready) {
		err = discord.UpdateStatus(0, "DungeonEternalX")
		if err != nil {
			log.WithFields(log.Fields{"Set Status": "0"}).Info("disdex.Discord:Error")
		}
		servers := discord.State.Guilds
		log.WithFields(log.Fields{"Started": 1, "Clients connected": len(servers)}).Info("disdex.Discord")
	})

	err = Discord.Open()
	errCheck("Error opening connection to Discord", err)
	defer Discord.Close()

	commandPrefix = "!"

	<-make(chan struct{})

	Discord.Close()
}

func errCheck(msg string, err error) {
	if err != nil {
		log.WithFields(log.Fields{"Message": msg, "Error": err}).Fatal("disdex.discord:error")
	}
}

func replyHandler(discord *discordgo.Session, message *discordgo.MessageCreate) {
	user := message.Author
	if user.ID == botID || user.Bot {
		//Do nothing because the bot is talking
		return
	}

	msg := message.Content
	// playercount
	if msg == "!playercount" {
		count, err := hgetRediskeyString("DungeonEternalX:server", "dm_password")
		if err != nil {
			log.Warnln("failed to perform hget operation on redis", err)
		}
		if count == "" {
			count = "no value "
		}
		_, err = Discord.ChannelMessageSendEmbed(message.ChannelID, &discordgo.MessageEmbed{
			Fields: []*discordgo.MessageEmbedField{
				{
					Name:   "PlayerCount",
					Value:  count,
					Inline: true,
				},
			},
		})
	}

	// dm password
	if msg == "!playercount"{
		count, err := hgetRediskeyString("DungeonEternalX:server", "dm_password")
		if err != nil {
			log.Warnln("failed to perform hget operation on redis", err)
		}
		if count == "" {
			count = "no value "
		}
		_, err = Discord.ChannelMessageSendEmbed(message.ChannelID, &discordgo.MessageEmbed{
			Fields: []*discordgo.MessageEmbedField{
				{
					Name:   "PlayerCount",
					Value:  count,
					Inline: true,
				},
			},
		})
	}

}