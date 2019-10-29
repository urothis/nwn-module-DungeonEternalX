FROM nwnxee/unified:latest
LABEL maintainer "urothis@gmail.com"
# grab the discord bot
RUN curl -o /usr/local/bin/dexbot gitlab.com/urothis/nwn-module-DungeonEternalX/-/jobs/artifacts/master/file/htmlcov/disdex?job=Build%20Disdex \
    && chmod +x /usr/local/bin/dexbot 
# grab the latest module
RUN  curl -o /nwn/home/server/modules gitlab.com/urothis/nwn-module-DungeonEternalX/-/jobs/artifacts/master/file/htmlcov/DungeonEternalX.mod?job=Build%20Disdex
CMD sh -c '/nwn/run-server.sh' \
    && dexbot