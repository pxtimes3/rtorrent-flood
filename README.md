## rTorrent with Flood for GUI.

Using https://github.com/jesec/flood due to the main repo being dead (https://github.com/Flood-UI/flood/issues/877)

Created for my own needs, don't rely on it being tip-top super-accurate up-to-date.

### USAGE

```
docker run -d \
--name rtorrent-flood \
-p 50000:50000 \
-p 3001:3000 \
-v <your download directory>:/download \
-v <watch torrent files in this directory>:/watch \
-v <rtorrent config>:/home/rtorrent/.session \
mamoco/rtorrent-flood
```
*Not really working but whatever

rTorrent is not listening to any http-requests (port 16819). Enable it if you need it or want the lizard people to mine crypto on your box.
rpc.socket (for Flood) is located at /home/rtorrent/rpc.socket

DHT is disabled

Edit rtorrent to your liking by diving in to the assets/config.d && .rtorrent.rc
