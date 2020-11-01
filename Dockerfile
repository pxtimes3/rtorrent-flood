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
    mkdir -p /home/rtorrent/config.d && \
    mkdir /home/rtorrent/.session && \
    mkdir /download && \
    mkdir /watch && \
    mkdir -p /usr/flood && \
    mkdir -p /var/log/s6 && \
    # ln -s /rtorrent/download /download && \
    # ln -s /rtorrent/watch /watch && \
    cd /usr/flood && \
    git clone https://github.com/jesec/flood . && \
    cp /assets/config.js /usr/flood/config.js && \
    cp /assets/config.d/ /home/rtorrent/config.d && \
    cp /assets/.rtorrent.rc /home/rtorrent && \
    npm config set unsafe-perm true && \
    npm install --prefix /usr/flood && \
    npm cache clean --force && \
    npm run build && \
    npm prune --production && \
    chown -R rtorrent:$UGID /home/rtorrent/ && \
    chown -R rtorrent:$UGID /home/rtorrent/.session && \
    chown -R rtorrent:$UGID /download && \
    chown -R rtorrent:$UGID /watch && \
    chown -R rtorrent:rtorrent /usr/flood && \
    chown -R rtorrent:rtorrent /assets && \
    chown -R rtorrent:rtorrent /var/log/s6

VOLUME /download /watch /home/rtorrent

EXPOSE 50000 3000

USER rtorrent

ENTRYPOINT [ "/bin/s6-svscan", "/assets/s6" ]