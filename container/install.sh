export DISPLAY=:0
Xvfb :0 -screen 0 1024x768x24 &
x11vnc -forever &
websockify --web /usr/share/novnc 8080 localhost:5900 &

winetricks -q windowscodecs
winetricks -q python26

wine pycrypto-2.6.1.win32-py2.6.exe
wine ADE_4.5_Installer.exe

while pgrep DigitalEditions >/dev/null; do sleep 1; done
wineserver --kill
