FROM alpine

ARG UGID=666

COPY ./assets /assets

# apk add --no-cache  --virtual=build-dependencies \
RUN set -x && addgroup -g $UGID rtorrent && \
    adduser -S -u $UGID -G rtorrent rtorrent && \
    apk add --virtual=build-dependencies \
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
    mv /assets/config.d/* /rtorrent/config.d && \
    mv /assets/.rtorrent.rc /rtorrent && \
    chown -R rtorrent:rtorrent /rtorrent && \
    chown -R rtorrent:rtorrent /download && \
    chown -R rtorrent:rtorrent /watch && \
    mkdir /usr/flood && \
    cd /usr/flood && \
    git clone https://github.com/jesec/flood . && \
    cp /assets/config.js . && \
    npm config set unsafe-perm true && \
    npm install --prefix /usr/flood && \
    npm cache clean --force && \
    npm run build && \
    npm prune --production && \
    chown -R rtorrent:rtorrent /usr/flood
#    mv /assets/init.sh /usr/local/bin/init.sh && \
#    chmod +x /usr/local/bin/init.sh

#COPY --chown=rtorrent:rtorrent config.d/ /home/rtorrent/config.d/
#COPY --chown=rtorrent:rtorrent .rtorrent.rc /home/rtorrent/

VOLUME /download /watch

EXPOSE 50000 3000

USER rtorrent

ENTRYPOINT [ "/bin/s6-svscan", "/assets/s6" ]