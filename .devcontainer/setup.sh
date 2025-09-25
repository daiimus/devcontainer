#!/bin/bash
set -e

# Evennia + BlightMUD Devcontainer Setup Script
# This script runs after container creation and sets up the development environment

# Configuration
SETUP_LOG="/home/vscode/devcontainer-logs/setup.log"
GELATINOUS_REPO="https://github.com/daiimus/gelatinous.git"
WORKSPACE_DIR="/home/vscode/workspace"
GELATINOUS_DIR="$WORKSPACE_DIR/gelatinous"

# Ensure log directory exists
mkdir -p "$(dirname "$SETUP_LOG")"

# Logging function
log() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" | tee -a "$SETUP_LOG"
}

# Error handling function
handle_error() {
    local line_number=$1
    local error_code=$2
    log "ERROR: Setup failed at line $line_number with exit code $error_code"
    log "Check the setup log at: $SETUP_LOG"
    log "You can run health checks with: ~/health-check.sh"
    exit $error_code
}

# Set up error handling
trap 'handle_error ${LINENO} $?' ERR

log "=== Starting Evennia + BlightMUD Development Environment Setup ==="
log "Setup log location: $SETUP_LOG"

# Ensure we're running as vscode user
if [ "$(whoami)" != "vscode" ]; then
    log "WARNING: Not running as vscode user. Current user: $(whoami)"
fi

# Update package lists
log "Updating package lists..."
sudo apt-get update -qq

# Check if Git is configured
log "Checking Git configuration..."
if ! git config --global user.name >/dev/null 2>&1; then
    log "Configuring Git with default settings..."
    git config --global user.name "VS Code User"
    git config --global user.email "vscode@example.com"
    git config --global init.defaultBranch main
fi

# Clone Gelatinous repository
log "Setting up Gelatinous project..."
cd "$WORKSPACE_DIR"

if [ -d "$GELATINOUS_DIR" ]; then
    log "Gelatinous directory already exists. Updating..."
    cd "$GELATINOUS_DIR"
    git pull origin main || log "WARNING: Failed to update Gelatinous repository"
else
    log "Cloning Gelatinous repository..."
    # Retry logic for cloning
    for attempt in 1 2 3; do
        if git clone "$GELATINOUS_REPO" gelatinous; then
            log "Successfully cloned Gelatinous repository on attempt $attempt"
            break
        else
            log "Clone attempt $attempt failed. Retrying in 5 seconds..."
            sleep 5
            if [ $attempt -eq 3 ]; then
                log "ERROR: Failed to clone Gelatinous repository after 3 attempts"
                exit 1
            fi
        fi
    done
fi

cd "$GELATINOUS_DIR"

# Install Python dependencies
log "Installing Python dependencies..."
if [ -f "requirements.txt" ]; then
    log "Installing from requirements.txt..."
    pip install --user -r requirements.txt
else
    log "No requirements.txt found, installing basic Evennia dependencies..."
    pip install --user evennia
fi

# Verify Evennia installation
log "Verifying Evennia installation..."
python -c "import evennia; print(f'Evennia version: {evennia.__version__}')" || {
    log "ERROR: Evennia verification failed"
    exit 1
}

# Initialize Evennia game if not already done
log "Checking Evennia game initialization..."
if [ ! -f "evennia.db" ] && [ ! -f "server/conf/settings.py" ]; then
    log "Initializing new Evennia game..."
    evennia --init gelatinous || {
        log "WARNING: Evennia init failed, game may already be initialized"
    }
fi

# Run database migrations
log "Running Evennia database migrations..."
evennia migrate || log "WARNING: Database migration failed or not needed"

# Set up BlightMUD configuration
log "Configuring BlightMUD..."
BLIGHTMUD_CONFIG_DIR="/home/vscode/.config/blightmud"
mkdir -p "$BLIGHTMUD_CONFIG_DIR"

# Create basic BlightMUD settings if they don't exist
if [ ! -f "$BLIGHTMUD_CONFIG_DIR/settings.ron" ]; then
    log "Creating default BlightMUD configuration..."
    cat > "$BLIGHTMUD_CONFIG_DIR/settings.ron" << 'EOF'
(
    logging_enabled: true,
    log_level: "info",
    confirm_quit: true,
    mouse_enabled: true,
    save_history: true,
    history_size: 1000,
    tts_enabled: false,
    reader_enabled: false,
)
EOF
fi

# Create convenient aliases
log "Setting up shell aliases..."
BASHRC="/home/vscode/.bashrc"

# Add aliases if they don't already exist
if ! grep -q "# Evennia Development Aliases" "$BASHRC"; then
    log "Adding development aliases to .bashrc..."
    cat >> "$BASHRC" << 'EOF'

# Evennia Development Aliases
alias evennia-start='cd ~/workspace/gelatinous && evennia start'
alias evennia-stop='cd ~/workspace/gelatinous && evennia stop'
alias evennia-restart='cd ~/workspace/gelatinous && evennia restart'
alias evennia-shell='cd ~/workspace/gelatinous && evennia shell'
alias evennia-logs='cd ~/workspace/gelatinous && evennia log'
alias blightmud='blightmud'
alias mud='blightmud'

# Development shortcuts
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Project shortcuts
alias cg='cd ~/workspace/gelatinous'
alias logs='tail -f ~/devcontainer-logs/*.log'
alias health='~/health-check.sh'

EOF
fi

# Create startup script
log "Creating startup script..."
cat > "/home/vscode/start-dev.sh" << 'EOF'
#!/bin/bash
echo "=== Evennia Development Environment ==="
echo "Welcome to your Evennia + BlightMUD development container!"
echo ""
echo "Quick commands:"
echo "  evennia-start    - Start the Evennia server"
echo "  evennia-stop     - Stop the Evennia server"
echo "  blightmud        - Start BlightMUD client"
echo "  health           - Run health checks"
echo "  logs             - View setup logs"
echo ""
echo "Your Gelatinous project is at: ~/workspace/gelatinous"
echo "Logs are available at: ~/devcontainer-logs/"
echo ""
cd ~/workspace/gelatinous
~/health-check.sh
EOF

chmod +x "/home/vscode/start-dev.sh"

# Create a simple connection script for BlightMUD
log "Creating BlightMUD connection script..."
cat > "/home/vscode/connect-local.sh" << 'EOF'
#!/bin/bash
echo "Starting BlightMUD and connecting to local Evennia server..."
echo "Make sure Evennia is running with: evennia-start"
echo ""
echo "To connect to localhost:4000, use the command: /connect localhost 4000"
echo "To quit BlightMUD, use: /quit"
echo ""
blightmud
EOF

chmod +x "/home/vscode/connect-local.sh"

# Run final health check
log "Running final health check..."
/home/vscode/health-check.sh >> "$SETUP_LOG" 2>&1

# Create setup completion marker
log "Creating setup completion marker..."
echo "Setup completed successfully at $(date)" > "/home/vscode/.devcontainer-setup-complete"

log "=== Setup Complete! ==="
log "You can now:"
log "  1. Start Evennia: evennia-start"
log "  2. Connect with BlightMUD: blightmud"
log "  3. Or run the startup script: ~/start-dev.sh"
log ""
log "All logs are available in ~/devcontainer-logs/"
log "Run 'health' command anytime to check system status"

# Source the new aliases for this session
source "$BASHRC"

log "Setup script finished successfully!"