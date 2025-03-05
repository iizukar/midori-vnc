#!/bin/bash

# Cleanup previous locks
rm -f /tmp/.X1-lock
rm -f /tmp/.X11-unix/X1

# Start virtual display
Xvfb :1 -screen 0 1024x768x16 +extension GLX +render -noreset &
export DISPLAY=:1

# Start window manager
fluxbox &

# Start VNC server
x11vnc -display :1 -rfbauth /root/.vnc/passwd -forever -shared -noxdamage -localhost -rfbport 5901 &

# Start noVNC
/opt/noVNC-1.4.0/utils/novnc_proxy \
    --vnc localhost:5901 \
    --listen ${PORT:-8080} \
    --heartbeat 30 \
    --cert /opt/noVNC-1.4.0/utils/self.pem \
    --web /opt/noVNC-1.4.0
