# build the discord bot binary
FROM golang:1.13.0 as dexbot
ADD disdex disdex
RUN apt update \
    && apt upgrade -y \
    && rm -r /var/lib/apt/lists /var/cache/apt \
    && git clone https://github.com/urothis/nwn-module-DungeonEternalX.git \
    && cd nwn-module-DungeonEternalX/disdex \
    && go mod download \
    && go build -o ./bin/dexbot \ 
    && mv nwn-module-DungeonEternalX/dexbot /usr/local/bin/

# build the module
FROM nasher:latest as module
COPY . /nasher
ENTRYPOINT [ "nasher" ]
CMD [ "pack" ""]

# put it all together into nwserver
FROM nwnxee/unified:latest
LABEL maintainer "urothis@gmail.com"
COPY --from=dexbot /usr/local/bin/dexbot /usr/local/bin/dexbot
COPY --from=module /nasher/server /nwn/home
RUN  chmod +x /usr/local/bin/dexbot 
CMD sh -c '/nwn/run-server.sh' \
    && dexbot