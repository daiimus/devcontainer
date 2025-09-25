FROM mcr.microsoft.com/devcontainers/python:3.11

# Install system dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        build-essential \
        curl \
        git \
        sqlite3 \
        libsqlite3-dev \
        postgresql-client \
        libpq-dev \
        redis-tools \
        telnet \
        netcat-openbsd \
        vim \
        tmux \
        htop \
        tree \
        jq \
        pkg-config \
        libssl-dev \
        libglib2.0-dev \
        libglib2.0-0 \
    && apt-get autoremove -y && apt-get clean -y

# Install Rust (needed for BlightMUD)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Create non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Switch to vscode user for remaining operations
USER $USERNAME

# Install Rust for the vscode user
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/vscode/.cargo/bin:${PATH}"

# Install Python packages globally that are commonly needed
RUN pip install --user --upgrade pip setuptools wheel

# Install Evennia dependencies
RUN pip install --user \
    evennia \
    django \
    twisted \
    pillow \
    pytz \
    python-decouple \
    django-extensions \
    black \
    flake8 \
    pylint

# Clone and build BlightMUD
RUN cd /tmp && \
    git clone https://github.com/blightmud/blightmud.git && \
    cd blightmud && \
    cargo build --release && \
    sudo cp target/release/blightmud /usr/local/bin/ && \
    cd / && rm -rf /tmp/blightmud

# Create workspace directory
RUN sudo mkdir -p /workspace && sudo chown $USERNAME:$USERNAME /workspace

# Set working directory
WORKDIR /workspace

# Expose Evennia ports
EXPOSE 4000 4001 4002 4005

# Default command
CMD ["/bin/bash"]