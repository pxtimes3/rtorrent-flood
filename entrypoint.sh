#!/bin/sh

rtorrent && npm run start && tail -f /var/log/* > /dev/null