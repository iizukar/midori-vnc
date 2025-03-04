FROM ubuntu:20.04

# Install dependencies with non-interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository universe \
    && apt-get update && apt-get install -y \
    midori \
    xvfb \
    fluxbox \
    x11vnc \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Rest of the Dockerfile remains the same...
