# build the module
FROM nasher:latest as module
COPY . /nasher
WORKDIR /nasher
RUN nasher pack

FROM nwnxee/unified:latest
LABEL maintainer "urothis@gmail.com"
RUN  curl -o /usr/local/bin/dexbot gitlab.com/urothis/nwn-module-DungeonEternalX/-/jobs/artifacts/master/file/htmlcov/index.html?job=Build%20Disdex
COPY --from=module /nasher/server /nwn/home
RUN  chmod +x /usr/local/bin/dexbot 
CMD sh -c '/nwn/run-server.sh' \
    && dexbot