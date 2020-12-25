#!/bin/bash

docker run -d --name=mamoco-rtorrent-flood \
--network host \
-v <yourwatch>:/watch \
-v <yourdownload>:/download \
-v <yourconfig>:/home/rtorrent \
-e PGID=0 -e PUID=0 -e TZ=Europe/Stockholm \
#-p 3000:3000 \ # network host makes these superfluous
#-p 50000:50000 \
mamoco/rtorrent-flood:latest
