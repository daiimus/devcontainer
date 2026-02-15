# Evennia Development Container
# Pinned to 3.13 because Evennia's current PyPI release uses distutils,
# which was removed in Python 3.14. Safe to move to 3.14+ once Evennia
# publishes a release that drops the distutils dependency.

FROM python:3.13-slim

# Install minimal system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Evennia
RUN pip install evennia
