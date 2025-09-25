# Ultra Simple Evennia + BlightMUD Development Container

FROM python:3.11-slim

# Install basic system packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create vscode user
RUN useradd --create-home --shell /bin/bash vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to vscode user
USER vscode
WORKDIR /home/vscode

# Install Evennia
RUN pip install --user evennia

# Download BlightMUD binary
RUN curl -L https://github.com/blightmud/blightmud/releases/latest/download/blightmud-linux.tar.gz -o blightmud.tar.gz \
    && tar -xzf blightmud.tar.gz \
    && mkdir -p .local/bin \
    && mv blightmud .local/bin/ \
    && rm blightmud.tar.gz

# Add local bin to PATH
ENV PATH="/home/vscode/.local/bin:${PATH}"

# Set working directory
WORKDIR /home/vscode

CMD ["/bin/bash"]
