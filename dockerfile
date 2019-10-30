FROM nwnxee/unified:latest
LABEL maintainer "urothis@gmail.com"
COPY $CI_PROJECT_DIR/DungeonEternalX.mod /nwn/home/server/modules/DungeonEternalX.mod
COPY $CI_PROJECT_DIR/_dexbot usr/local/bin/_dexbot
RUN chmod +x /usr/local/bin/_dexbot
CMD sh -c '/nwn/run-server.sh' \
    && _dexbot