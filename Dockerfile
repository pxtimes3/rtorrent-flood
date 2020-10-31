FROM alpine

ARG UGID=666

RUN addgroup -g $UGID rtorrent && \
    adduser -S -u $UGID -G rtorrent rtorrent && \
    apk add --no-cache rtorrent && \
    mkdir -p /home/rtorrent/rtorrent/config.d && \
    mkdir /home/rtorrent/rtorrent/.session && \
    mkdir /home/rtorrent/rtorrent/download && \
    mkdir /home/rtorrent/rtorrent/watch && \
    chown -R rtorrent:rtorrent /home/rtorrent/rtorrent

RUN apk add --no-cache --virtual=build-dependencies python3 git nodejs nodejs-npm build-base && \
    #npm i -g --unsafe-perm --silent flood
    mkdir /floodtemp && \
    chown -R rtorrent:rtorrent /floodtemp

COPY --chown=rtorrent:rtorrent config.js /floodtemp

RUN mkdir /usr/flood && \
    cd /usr/flood && \
    git clone https://github.com/jesec/flood . && \
    cp /floodtemp/config.js . && \
    npm config set unsafe-perm true && \
    npm install --prefix /usr/flood && \
    npm cache clean --force && \
    npm run build && \
    npm prune --production && \
    rm -rf /floodtemp && \
    chown -R rtorrent:rtorrent /usr/flood

COPY --chown=rtorrent:rtorrent config.d/ /home/rtorrent/rtorrent/config.d/
COPY --chown=rtorrent:rtorrent .rtorrent.rc /home/rtorrent/

VOLUME /home/rtorrent/rtorrent/.session

EXPOSE 16891 50000 6881 6881/udp 3000

USER rtorrent

CMD ["rtorrent", "flood"]