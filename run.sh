#!/bin/bash


docker run -d \
--name rtf \
-p 50000:50000 \
-p 3001:3000 \
-v /Users/px/dev/rtorrent-flood/config:/rtorrent \
-v /Users/px/dev/rtorrent-flood/download:/download \
-v /Users/px/dev/rtorrent-flood/watch:/watch \
rtorrentflood:latest