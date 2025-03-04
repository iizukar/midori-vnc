#!/bin/bash
# Start services sequentially to save resources

# Virtual display with smaller resolution
Xvfb :1 -screen 0 1024x768x16 &
export DISPLAY=:1

# Start window manager
fluxbox &

# Start VNC server with low quality settings
x11vnc -display :1 -rfbauth /root/.vnc/passwd -forever -shared -noxdamage -localhost -rfbport 5901 -bg

# Start noVNC with basic auth
/opt/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen ${PORT:-8080} --heartbeat 30
