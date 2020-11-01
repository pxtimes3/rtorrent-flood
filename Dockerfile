FROM alpine

ARG UGID=666

COPY ./assets /assets

RUN addgroup -g $UGID rtorrent && \
    adduser -S -u $UGID -G rtorrent rtorrent && \
    apk add --no-cache --virtual=build-dependencies \
        s6 \
        bash \
        rtorrent \
        python3 \
        git \
        nodejs \
        nodejs-npm \
        build-base && \
    mkdir -p /rtorrent/config.d && \
    mkdir /rtorrent/.session && \
    mkdir /download && \
    mkdir /watch && \
    mkdir -p /usr/flood && \
    mkdir -p /var/log/s6 && \
    # ln -s /rtorrent/download /download && \
    # ln -s /rtorrent/watch /watch && \
    cd /usr/flood && \
    git clone https://github.com/jesec/flood . && \
    mv /assets/config.js /usr/flood/config.js && \
    mv /assets/config.d/* /rtorrent/config.d && \
    mv /assets/.rtorrent.rc /rtorrent && \
    npm config set unsafe-perm true && \
    npm install --prefix /usr/flood && \
    npm cache clean --force && \
    npm run build && \
    npm prune --production && \
    chown -R rtorrent:$UGID /rtorrent/ && \
    chown -R rtorrent:$UGID /rtorrent/.session && \
    chown -R rtorrent:$UGID /download && \
    chown -R rtorrent:$UGID /watch && \
    chown -R rtorrent:rtorrent /usr/flood && \
    chown -R rtorrent:rtorrent /assets && \
    chown -R rtorrent:rtorrent /var/log/s6

VOLUME /download /watch /rtorrent /usr/flood

EXPOSE 50000 3000

USER rtorrent

ENTRYPOINT [ "/bin/s6-svscan", "/assets/s6" ]