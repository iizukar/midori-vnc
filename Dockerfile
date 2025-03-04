FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install core packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    midori \
    xvfb \
    x11vnc \
    tightvncserver \
    fluxbox \
    net-tools \
    openssl \
    python3 \
    python3-websockify \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download and install noVNC + websockify
ADD https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz /tmp/
ADD https://github.com/novnc/websockify/archive/v0.11.0.tar.gz /tmp/
RUN tar -xzf /tmp/v1.4.0.tar.gz -C /opt && \
    tar -xzf /tmp/v0.11.0.tar.gz -C /opt/noVNC-1.4.0/utils/ && \
    mv /opt/noVNC-1.4.0/utils/websockify-0.11.0 /opt/noVNC-1.4.0/utils/websockify && \
    rm -rf /tmp/*.tar.gz

# Generate SSL certificate
RUN openssl req -new -x509 -days 365 -nodes \
    -out /opt/noVNC-1.4.0/utils/self.pem \
    -keyout /opt/noVNC-1.4.0/utils/self.pem \
    -subj "/C=US/ST=Earth/L=Global/O=Midori/CN=render"

# Configure VNC
RUN mkdir -p /root/.vnc && \
    echo "password" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Fluxbox configuration
RUN mkdir -p /root/.fluxbox && \
    echo 'session.screen0.workspaces: 1' > /root/.fluxbox/init && \
    echo 'midori --display=:1' > /root/.fluxbox/startup

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080
CMD ["/start.sh"]
