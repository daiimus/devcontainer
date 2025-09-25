# Evennia + BlightMUD Development Container

FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    libasound2t64 \
    && rm -rf /var/lib/apt/lists/*

# Install Evennia
RUN pip install evennia

# Install BlightMUD from official .deb package  
RUN BLIGHTMUD_URL=$(curl -s https://api.github.com/repos/blightmud/blightmud/releases/latest | grep "browser_download_url.*amd64\.deb" | cut -d '"' -f 4) \
    && curl -L "$BLIGHTMUD_URL" -o blightmud.deb \
    && apt-get update \
    && apt-get install -y ./blightmud.deb \
    && rm blightmud.deb \
    && rm -rf /var/lib/apt/lists/*
