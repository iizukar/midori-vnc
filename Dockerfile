FROM debian:buster-slim

# Install minimal requirements
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    midori \
    xvfb \
    x11vnc \
    tightvncserver \
    fluxbox \
    net-tools \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install noVNC directly
ADD https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.tar.gz /tmp/
RUN tar -xzf /tmp/v1.4.0.tar.gz -C /opt/ \
    && mv /opt/noVNC-1.4.0 /opt/noVNC \
    && rm /tmp/v1.4.0.tar.gz

# Configure VNC password
RUN mkdir -p /root/.vnc && \
    echo "password" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Minimal fluxbox config
RUN mkdir -p /root/.fluxbox && \
    echo "midori --display=:1" > /root/.fluxbox/startup

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080
CMD ["/start.sh"]
