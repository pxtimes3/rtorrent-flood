**USAGE**

```
docker run -d \
--name rtorrent-flood \
-p 50000:50000 \
-p 3001:3000 \
-v <your download directory>:/download \
-v <watch torrent files in this directory>:/watch \
mamoco/rtorrent-flood
```

rpc.socket is located at /rtorrent/rpc.socket

DHT is disabled

Edit rtorrent to your liking by diving in to the assets/config.d && .rtorrent.rc
