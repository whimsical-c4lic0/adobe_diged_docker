FROM ubuntu:22.04

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8

RUN    dpkg --add-architecture i386
RUN    apt-get update && apt-get -y install python3 python-is-python3 xvfb x11vnc xdotool wget tar supervisor net-tools fluxbox gnupg2 websockify novnc
RUN    echo 'echo -n $HOSTNAME' > /root/x11vnc_password.sh && chmod +x /root/x11vnc_password.sh
RUN    wget -O - https://dl.winehq.org/wine-builds/winehq.key | apt-key add -
RUN    echo 'deb https://dl.winehq.org/wine-builds/ubuntu/ jammy main' | tee /etc/apt/sources.list.d/winehq.list
RUN    apt-get update && apt-get -y install winehq-stable=9.0.0.0~jammy-1
RUN    mkdir /opt/wine-stable/share/wine/mono && wget -O /opt/wine-stable/share/wine/mono/wine-mono-7.0.0-x86.msi https://dl.winehq.org/wine/wine-mono/7.0.0/wine-mono-7.0.0-x86.msi
RUN    mkdir /opt/wine-stable/share/wine/gecko && wget -O /opt/wine-stable/share/wine/gecko/wine-gecko-2.47.4-x86.msi https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86.msi && wget -O /opt/wine-stable/share/wine/gecko/wine-gecko-2.47.4-x86_64.msi https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86_64.msi
RUN    apt-get -y full-upgrade && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV WINEPREFIX /app/.wine
ENV WINEARCH win32
ENV DISPLAY :0

RUN apt-get update && apt-get install -y \
    wine \
    winetricks \
    x11vnc \
    xvfb \
    procps \
 && rm -rf /var/lib/apt/lists/*

RUN winetricks -q corefonts
RUN winetricks -q dotnet40

RUN echo "<!DOCTYPE html><html><head><meta http-equiv=\"Refresh\" content=\"0; url='vnc.html'\" /></head><body></body></html>" > /usr/share/novnc/index.html

EXPOSE 8080

COPY container/ .
