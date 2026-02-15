# Evennia Development Container
# Pinned to 3.13 (Evennia's recommended version). setuptools is included
# because Evennia's current PyPI release imports distutils, which was
# removed from Python's stdlib in 3.12. setuptools provides the shim.
# Both the pin and setuptools can be dropped once Evennia publishes a
# release that uses `packaging` instead of `distutils`.

FROM python:3.13-slim

# Install minimal system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Evennia (setuptools provides distutils compatibility shim)
RUN pip install setuptools evennia
