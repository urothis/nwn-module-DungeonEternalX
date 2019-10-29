FROM nwnxee/unified:latest
LABEL maintainer "urothis@gmail.com"
RUN chmod +x /usr/local/bin/dexbot 
CMD sh -c '/nwn/run-server.sh' \
    && _dexbot