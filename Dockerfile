FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install essential packages with cleanup
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    midori \
    xvfb \
    x11vnc \
    tightvncserver \
    fluxbox \
    net-tools \
    openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download and install noVNC + websockify
ADD https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz /tmp/
ADD https://github.com/novnc/websockify/archive/v0.11.0.tar.gz /tmp/
RUN tar -xzf /tmp/v1.4.0.tar.gz -C /opt && \
    tar -xzf /tmp/v0.11.0.tar.gz -C /opt/noVNC-1.4.0/utils/ && \
    mv /opt/noVNC-1.4.0/utils/websockify-0.11.0 /opt/noVNC-1.4.0/utils/websockify && \
    rm -rf /tmp/*.tar.gz

# Configure VNC
RUN mkdir -p /root/.vnc && \
    echo "password" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Basic fluxbox configuration
RUN mkdir -p /root/.fluxbox && \
    echo 'session.screen0.workspaces: 1' > /root/.fluxbox/init && \
    echo 'midori --display=:1' > /root/.fluxbox/startup

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080
CMD ["/start.sh"]
