#!/bin/sh

cd /usr/flood 
npm start > npmstart 2>&1 & 
rtorrent -I -D -n -o import=/rtorrent/.rtorrent.rc > rtorrentstart 2>&1 & 
tail -f /var/log/* > /dev/null
#monkey