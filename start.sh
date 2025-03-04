#!/bin/bash

# Start virtual framebuffer
Xvfb :1 -screen 0 1280x720x16 &
export DISPLAY=:1

# Start Fluxbox window manager
fluxbox &

# Start VNC server (port 5901)
x11vnc -display :1 -rfbauth /root/.vnc/passwd -forever -shared -noxdamage &

# Start noVNC (port 8080 by default; Render uses $PORT)
/opt/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen ${PORT:-8080}
