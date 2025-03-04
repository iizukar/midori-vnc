#!/bin/bash

# Start virtual framebuffer with larger screen
Xvfb :1 -screen 0 1920x1080x16 &
export DISPLAY=:1

# Start Fluxbox window manager
fluxbox &

# Start VNC server (port 5901)
x11vnc -display :1 -rfbauth /root/.vnc/passwd -forever -shared -noxdamage &

# Start noVNC with proper port configuration
/opt/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen ${PORT:-8080} --heartbeat 30
