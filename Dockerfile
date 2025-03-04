FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    midori \
    xvfb \
    fluxbox \
    x11vnc \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Clone noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC

# Set VNC password (default: "password")
RUN mkdir -p /root/.vnc && \
    echo "password" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Configure Fluxbox to auto-start Midori
RUN mkdir -p /root/.fluxbox && \
    echo "midori &" > /root/.fluxbox/startup

# Copy start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose default noVNC port (Render will override this)
EXPOSE 8080

CMD ["/start.sh"]
