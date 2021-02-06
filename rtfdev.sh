#!/bin/bash

docker run -d --name=rtfdev \
--network host \
-v /home/px/watch:/watch \
-v /4tb1/tSeed:/download \
-v /home/px/.config/rtf/rtorrent:/home/rtorrent \
-e PGID=0 -e PUID=0 -e TZ=Europe/Stockholm \
rtfdev:latest
