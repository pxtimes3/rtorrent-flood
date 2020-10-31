#ARG BASEIMAGE_VERSION
FROM tuxmealux/alpine-rtorrent

MAINTAINER pxtimes3

# set version label
ARG BUILD_DATE=""
ARG VERSION=""
LABEL build_version="pxtimes3 version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# package version
ARG MEDIAINF_VER="20.03"
ARG CURL_VER="7.71.0"
ARG GEOIP_VER="1.1.1"
ARG RTORRENT_VER="v0.9.7"
ARG LIBTORRENT_VER="v0.13.8"
# wtf? ARG MAXMIND_LICENSE_KEY

# set env
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV CONTEXT_PATH=/
ENV CREATE_SUBDIR_BY_TRACKERS="no"
ENV SSL_ENABLED="no"

# install flood webui
RUN apk add --no-cache \
      python \
      nodejs \
      nodejs-npm && \
    apk add --no-cache --virtual=build-dependencies \
      build-base && \
    mkdir /usr/flood && \
    cd /usr/flood && \
    git clone https://github.com/jesec/flood . && \
    cp config.template.js config.js && \
    npm config set unsafe-perm true && \
    npm install --prefix /usr/flood && \
    npm cache clean --force && \
    npm run build && \
    npm prune --production && \
    rm config.js && \
    apk del --purge build-dependencies && \
    rm -rf /root \
           /tmp/* && \
    ln -s /usr/local/bin/mediainfo /usr/bin/mediainfo

# add local files
COPY root/ /
COPY VERSION /

# ports and volumes
EXPOSE 50000 6881 51415 3000
VOLUME /config /downloads
