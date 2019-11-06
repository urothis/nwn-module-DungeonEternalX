FROM nwnxee/unified:latest
LABEL maintainer "urothis@gmail.com"
ARG CI_REGISTRY_USER
ENV CI_REGISTRY_USER=${CI_REGISTRY_USER}
ARG CI_REGISTRY_PASSWORD
ENV CI_REGISTRY_PASSWORD=${CI_REGISTRY_PASSWORD}
ARG NWNX_ADMINISTRATION_SKIP
ENV NWNX_ADMINISTRATION_SKIP=${NWNX_ADMINISTRATION_SKIP} 
ARG NWNX_CHAT_SKIP
ENV NWNX_CHAT_SKIP=${NWNX_CHAT_SKIP}
ARG NWNX_CORE_LOG_LEVEL
ENV NWNX_CORE_LOG_LEVEL=${NWNX_CORE_LOG_LEVEL}
ARG NWNX_CORE_SKIP_ALL
ENV NWNX_CORE_SKIP_ALL=${NWNX_CORE_SKIP_ALL}
ARG NWNX_CORE_SHUTDOWN_SCRIPT
ENV NWNX_CORE_SHUTDOWN_SCRIPT=${NWNX_CORE_SHUTDOWN_SCRIPT}
ARG NWNX_CREATURE_SKIP
ENV NWNX_CREATURE_SKIP=${NWNX_CREATURE_SKIP}
ARG NWNX_EVENT_SKIP
ENV NWNX_EVENT_SKIP=${NWNX_EVENT_SKIP}
ARG NWNX_SQL_DATABASE
ENV NWNX_SQL_DATABASE=${NWNX_SQL_DATABASE}
ARG NWNX_SQL_HOST
ENV NWNX_SQL_HOST=${NWNX_SQL_HOST}
ARG NWNX_SQL_PASSWORD
ENV NWNX_SQL_PASSWORD=${NWNX_SQL_PASSWORD}
ARG NWNX_SQL_SKIP
ENV NWNX_SQL_SKIP=${NWNX_SQL_SKIP}
ARG NWNX_SQL_TYPE
ENV NWNX_SQL_TYPE=${NWNX_SQL_TYPE}
ARG NWNX_SQL_USERNAME
ENV NWNX_SQL_USERNAME=${NWNX_SQL_USERNAME}
ARG NWNX_TIME_SKIP
ENV NWNX_TIME_SKIP=${NWNX_TIME_SKIP}
ARG NWNX_TWEAKS_DISABLE_MONK_ABILITIES_WHEN_POLYMORPHED
ENV NWNX_TWEAKS_DISABLE_MONK_ABILITIES_WHEN_POLYMORPHED=${NWNX_TWEAKS_DISABLE_MONK_ABILITIES_WHEN_POLYMORPHED}
ARG NWNX_TWEAKS_DISABLE_PAUSE
ENV NWNX_TWEAKS_DISABLE_PAUSE=${NWNX_TWEAKS_DISABLE_PAUSE}
ARG NWNX_TWEAKS_FIX_GREATER_SANCTUARY_BUG
ENV NWNX_TWEAKS_FIX_GREATER_SANCTUARY_BUG=${NWNX_TWEAKS_FIX_GREATER_SANCTUARY_BUG}
ARG NWNX_TWEAKS_HIDE_CLASSES_ON_CHAR_LIST
ENV NWNX_TWEAKS_HIDE_CLASSES_ON_CHAR_LIST=${NWNX_TWEAKS_HIDE_CLASSES_ON_CHAR_LIST}
ARG NWNX_TWEAKS_SKIP
ENV NWNX_TWEAKS_SKIP=${NWNX_TWEAKS_SKIP}
ARG NWNX_EVENTS_SKIP
ENV NWNX_EVENTS_SKIP=${NWNX_EVENTS_SKIP}
ARG NWNX_WEBHOOK_PRIVATE_CHANNEL
ENV NWNX_WEBHOOK_PRIVATE_CHANNEL=${NWNX_WEBHOOK_PRIVATE_CHANNEL}
ARG NWNX_WEBHOOK_PUBLIC_CHANNEL
ENV NWNX_WEBHOOK_PUBLIC_CHANNEL=${NWNX_WEBHOOK_PUBLIC_CHANNEL}
ARG NWNX_WEBHOOK_SKIP
ENV NWNX_WEBHOOK_SKIP=${NWNX_WEBHOOK_SKIP}
ARG NWN_AUTOSAVEINTERVAL
ENV NWN_AUTOSAVEINTERVAL=${NWN_AUTOSAVEINTERVAL}
ARG NWN_DIFFICULTY
ENV NWN_DIFFICULTY=${NWN_DIFFICULTY}
ENV NWN_PLAYERPASSWORD=dex
ARG NWN_DMPASSWORD
ENV NWN_DMPASSWORD=${NWN_DMPASSWORD}
ARG NWN_ELC
ENV NWN_ELC=${NWN_ELC}
ARG NWN_GAMETYPE
ENV NWN_GAMETYPE=${NWN_GAMETYPE}
ARG NWN_ILR
ENV NWN_ILR=${NWN_ILR}
ARG NWN_MAXCLIENTS
ENV NWN_MAXCLIENTS=${NWN_MAXCLIENTS}
ARG NWN_MAXLEVEL
ENV NWN_MAXLEVEL=${NWN_MAXLEVEL}
ARG NWN_MINLEVEL
ENV NWN_MINLEVEL=${NWN_MINLEVEL}
ARG NWN_MODULE
ENV NWN_MODULE=${NWN_MODULE}
ARG NWN_ONEPARTY
ENV NWN_ONEPARTY=${NWN_ONEPARTY}
ARG NWN_PAUSEANDPLAY
ENV NWN_PAUSEANDPLAY=${NWN_PAUSEANDPLAY}
ARG NWN_PORT
ENV NWN_PORT=${NWN_PORT}
ARG NWN_PUBLICSERVER
ENV NWN_PUBLICSERVER=${NWN_PUBLICSERVER}
ARG NWN_PVP
ENV NWN_PVP=${NWN_PVP}
ARG NWN_RELOADWHENEMPTY
ENV NWN_RELOADWHENEMPTY=${NWN_RELOADWHENEMPTY}
ARG NWN_SERVERVAULT
ENV NWN_SERVERVAULT=${NWN_SERVERVAULT} 
COPY $CI_PROJECT_DIR/DungeonEternalX.mod /nwn/data/data/mod/DungeonEternalX.mod