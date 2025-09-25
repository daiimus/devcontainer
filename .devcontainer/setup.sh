#!/bin/bash

set -e

echo "🚀 Starting devcontainer setup for Evennia development..."

# Ensure we're in the workspace directory
cd /workspace

# Update PATH for current session
export PATH="/home/vscode/.local/bin:$PATH"
export PATH="/home/vscode/.cargo/bin:$PATH"

# Add paths to .bashrc for future sessions
echo 'export PATH="/home/vscode/.local/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="/home/vscode/.cargo/bin:$PATH"' >> ~/.bashrc

# Clone the Gelatinous repository if it doesn't exist
if [ ! -d "gelatinous" ]; then
    echo "📦 Cloning Gelatinous repository..."
    git clone https://github.com/daiimus/gelatinous.git
    cd gelatinous
    
    # Install any Python dependencies for Gelatinous if requirements.txt exists
    if [ -f "requirements.txt" ]; then
        echo "📋 Installing Gelatinous requirements..."
        pip install --user -r requirements.txt
    fi
    
    # If it's an Evennia game, initialize it
    if [ -f "server.py" ] || [ -f "manage.py" ]; then
        echo "🎮 Setting up Evennia game..."
        evennia migrate
    fi
    
    cd /workspace
else
    echo "📦 Gelatinous repository already exists, pulling latest changes..."
    cd gelatinous
    git pull
    cd /workspace
fi

# Create a sample BlightMUD configuration if it doesn't exist
if [ ! -f "/home/vscode/.config/blightmud/settings.ron" ]; then
    echo "⚙️ Creating BlightMUD configuration..."
    mkdir -p /home/vscode/.config/blightmud
    cat > /home/vscode/.config/blightmud/settings.ron << 'EOF'
(
    mud_connections: [],
    tts_enabled: false,
    tts_rate: 0,
    tts_pitch: 0,
    confirm_quit: true,
    mouse_enabled: true,
    vi_mode: false,
    tab_completion_enabled: true,
    save_password: false,
    auto_login: false,
    logging_enabled: true,
    log_format: "txt",
    prompt_input: "> ",
    prompt_input_color: "White",
    theme_name: "default",
)
EOF
fi

# Create useful aliases
echo "🔧 Setting up aliases..."
cat >> ~/.bashrc << 'EOF'

# Evennia aliases
alias evennia-start='cd /workspace/gelatinous && evennia start'
alias evennia-stop='cd /workspace/gelatinous && evennia stop'
alias evennia-restart='cd /workspace/gelatinous && evennia restart'
alias evennia-shell='cd /workspace/gelatinous && evennia shell'

# BlightMUD aliases
alias blightmud='blightmud'
alias mud='blightmud'

# Development aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'

EOF

echo "✅ Setup complete! Available commands:"
echo "  - evennia-start: Start the Evennia server"
echo "  - evennia-stop: Stop the Evennia server"
echo "  - evennia-restart: Restart the Evennia server"
echo "  - evennia-shell: Open Evennia shell"
echo "  - blightmud: Start BlightMUD client"
echo ""
echo "📁 Your Gelatinous project is in: /workspace/gelatinous"
echo "🌐 Evennia web interface will be available on port 4005"
echo "🔌 Evennia server will listen on ports 4000-4002"
echo ""
echo "🎉 Happy coding!"