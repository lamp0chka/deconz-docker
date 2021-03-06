FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
apt-get install -y --no-install-recommends \
ca-certificates \
curl \
libqt5core5a \
libqt5network5 \
libqt5widgets5 \
libqt5gui5 \
libqt5serialport5 \
libqt5websockets5 \
libqt5sql5 \
sqlite3 && \
apt-get clean

ENV DECONZ_VERSION 2.05.01

RUN curl -O https://www.dresden-elektronik.de/deconz/ubuntu/beta/deconz-${DECONZ_VERSION}-qt5.deb && \
dpkg -i deconz-${DECONZ_VERSION}-qt5.deb && \
rm deconz-${DECONZ_VERSION}-qt5.deb

RUN chown root:root /usr/bin/deCONZ*
RUN mkdir /root/otau
RUN mkdir -p /run/udev/data/ && \
echo "E:ID_VENDOR_ID=0403\nE:ID_MODEL_ID=6015" > /run/udev/data/c188:0

VOLUME ["/root/.local/share/dresden-elektronik/deCONZ"]
EXPOSE 8080

CMD /usr/bin/deCONZ --auto-connect=1 -platform minimal --upnp=0 --http-port=8080 --dbg-error=1
