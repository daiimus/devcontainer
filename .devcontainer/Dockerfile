# Simple Evennia + BlightMUD Development Container
# Using packages instead of compilation for reliability

FROM python:3.11-slim

# Set environment variables to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies including OpenSSL dev packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Essential build tools
    build-essential \
    pkg-config \
    # Git and downloads
    git \
    curl \
    wget \
    # OpenSSL development packages (needed for Rust/BlightMUD)
    libssl-dev \
    libssl3 \
    # Database support for Evennia
    sqlite3 \
    libsqlite3-dev \
    # Network tools for debugging
    net-tools \
    telnet \
    netcat-openbsd \
    # Additional utilities
    tree \
    htop \
    vim \
    nano \
    # Security
    ca-certificates \
    gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "System packages installed successfully" > /var/log/devcontainer/system-packages.log

# Create vscode user with proper permissions
RUN useradd --create-home --shell /bin/bash vscode \
    && usermod -aG sudo vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && mkdir -p /home/vscode/.config/blightmud \
    && chown -R vscode:vscode /home/vscode

# Copy logs to vscode accessible location
RUN cp -r /var/log/devcontainer /home/vscode/devcontainer-logs \
    && chown -R vscode:vscode /home/vscode/devcontainer-logs

# Switch to vscode user
USER vscode
WORKDIR /home/vscode

# Install Evennia via pip (much faster than compilation)
RUN python -m pip install --upgrade pip \
    && pip install --user evennia \
    && echo "Evennia installed: $(pip show evennia | grep Version)" > /home/vscode/devcontainer-logs/evennia-install.log

# Download BlightMUD pre-built binary (avoid compilation)
RUN curl -L https://github.com/blightmud/blightmud/releases/latest/download/blightmud-linux.tar.gz -o /tmp/blightmud.tar.gz \
    && cd /tmp \
    && tar -xzf blightmud.tar.gz \
    && mkdir -p /home/vscode/.local/bin \
    && mv blightmud /home/vscode/.local/bin/ \
    && chmod +x /home/vscode/.local/bin/blightmud \
    && rm blightmud.tar.gz \
    && echo "BlightMUD binary installed" > /home/vscode/devcontainer-logs/blightmud-install.log

# Update PATH for local binaries
ENV PATH="/home/vscode/.local/bin:${PATH}"

# Verify installations
RUN python -c "import evennia; print(f'Evennia version: {evennia.__version__}')" \
    && blightmud --version \
    && echo "All installations verified successfully" >> /home/vscode/devcontainer-logs/install-verification.log

# Create workspace directory
RUN mkdir -p /home/vscode/workspace

# Health check script
RUN echo '#!/bin/bash\n\
set -e\n\
echo "=== Devcontainer Health Check ==="\n\
echo "Timestamp: $(date)"\n\
echo "Checking Python..."\n\
python --version\n\
python -c "import evennia; print(f'\''Evennia version: {evennia.__version__}'\'')" \n\
echo "Checking BlightMUD..."\n\
blightmud --version\n\
echo "Checking network tools..."\n\
which telnet && which nc\n\
echo "Installation logs available at:"\n\
ls -la /home/vscode/devcontainer-logs/\n\
echo "=== Health Check Complete ==="\n' > /home/vscode/health-check.sh \
    && chmod +x /home/vscode/health-check.sh

# Set working directory
WORKDIR /home/vscode/workspace

# Default command
CMD ["/bin/bash"]
