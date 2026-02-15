# Evennia Development Container

FROM python:3-slim

# Install minimal system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Evennia
RUN pip install evennia
