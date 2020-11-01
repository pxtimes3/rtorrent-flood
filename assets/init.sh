#!/bin/sh

cd /usr/flood 
npm start
rtorrent -I -n -o import=/rtorrent/.rtorrent.rc&