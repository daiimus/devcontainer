# Evennia + BlightMUD Development Container
# Multi-stage build for better reliability and caching

FROM python:3.11-slim as base

# Set environment variables to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV RUST_LOG=info

# Create log directory early
RUN mkdir -p /var/log/devcontainer

# Install system dependencies with error handling
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Build essentials
    build-essential \
    pkg-config \
    # Git and version control
    git \
    curl \
    wget \
    # Database support for Evennia
    sqlite3 \
    libsqlite3-dev \
    # Network tools for debugging
    net-tools \
    telnet \
    netcat-openbsd \
    # Process management
    supervisor \
    # Additional utilities
    tree \
    htop \
    vim \
    nano \
    # SSL and security
    ca-certificates \
    gnupg \
    lsb-release \
    # Development tools
    make \
    gcc \
    g++ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "System packages installed successfully" > /var/log/devcontainer/system-packages.log

# Install Rust and Cargo with error handling
FROM base as rust-installer
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && echo "Rust installation completed" > /var/log/devcontainer/rust-install.log
ENV PATH="/root/.cargo/bin:${PATH}"

# Verify Rust installation
RUN rustc --version && cargo --version \
    && echo "Rust verification passed: $(rustc --version)" >> /var/log/devcontainer/rust-install.log

# Build BlightMUD from source with error handling
FROM rust-installer as blightmud-builder
WORKDIR /tmp/blightmud

# Clone BlightMUD with error handling and retry
RUN set -e; \
    for i in 1 2 3; do \
        git clone https://github.com/blightmud/blightmud.git . && break || \
        (echo "Attempt $i failed, retrying..." && sleep 5); \
    done && \
    echo "BlightMUD cloned successfully" > /var/log/devcontainer/blightmud-clone.log

# Build BlightMUD with resource constraints for Codespaces
RUN set -e; \
    echo "Starting BlightMUD build..." && \
    # Limit parallelism to prevent OOM in Codespaces
    export CARGO_BUILD_JOBS=2 && \
    cargo build --release --verbose 2>&1 | tee /var/log/devcontainer/blightmud-build.log && \
    echo "BlightMUD build completed successfully" >> /var/log/devcontainer/blightmud-build.log

# Final stage - combine everything
FROM base as final

# Copy Rust toolchain
COPY --from=rust-installer /root/.cargo /root/.cargo
COPY --from=rust-installer /root/.rustup /root/.rustup
ENV PATH="/root/.cargo/bin:${PATH}"

# Copy BlightMUD binary
COPY --from=blightmud-builder /tmp/blightmud/target/release/blightmud /usr/local/bin/blightmud
COPY --from=blightmud-builder /var/log/devcontainer/blightmud-*.log /var/log/devcontainer/

# Create vscode user with proper permissions
RUN useradd --create-home --shell /bin/bash vscode \
    && usermod -aG sudo vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && mkdir -p /home/vscode/.config/blightmud \
    && chown -R vscode:vscode /home/vscode

# Copy logs to vscode accessible location
RUN cp -r /var/log/devcontainer /home/vscode/devcontainer-logs \
    && chown -R vscode:vscode /home/vscode/devcontainer-logs

# Install Python dependencies for Evennia
USER vscode
WORKDIR /home/vscode

# Upgrade pip and install Evennia with error handling
RUN python -m pip install --upgrade pip \
    && pip install --user evennia \
    && echo "Evennia installed: $(pip show evennia | grep Version)" > /home/vscode/devcontainer-logs/evennia-install.log

# Verify installations
RUN python -c "import evennia; print(f'Evennia version: {evennia.__version__}')" \
    && blightmud --version \
    && echo "All installations verified successfully" >> /home/vscode/devcontainer-logs/install-verification.log

# Create workspace directory
RUN mkdir -p /home/vscode/workspace

# Health check script
COPY --chown=vscode:vscode <<'EOF' /home/vscode/health-check.sh
#!/bin/bash
set -e

echo "=== Devcontainer Health Check ==="
echo "Timestamp: $(date)"

# Check Python and Evennia
echo "Checking Python..."
python --version
python -c "import evennia; print(f'Evennia version: {evennia.__version__}')"

# Check Rust and BlightMUD
echo "Checking Rust..."
rustc --version
blightmud --version

# Check network tools
echo "Checking network tools..."
which telnet && which nc

# Check logs
echo "Installation logs available at:"
ls -la /home/vscode/devcontainer-logs/

echo "=== Health Check Complete ==="
EOF

RUN chmod +x /home/vscode/health-check.sh

# Set working directory
WORKDIR /home/vscode/workspace

# Default command
CMD ["/bin/bash"]