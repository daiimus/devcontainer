#!/bin/bash

# Devcontainer Diagnostic and Troubleshooting Script
# Run this when things go wrong to gather debug information

LOG_DIR="/home/vscode/devcontainer-logs"
DIAG_LOG="$LOG_DIR/diagnostics-$(date +%Y%m%d-%H%M%S).log"

mkdir -p "$LOG_DIR"

echo "=== Devcontainer Diagnostics ===" | tee "$DIAG_LOG"
echo "Timestamp: $(date)" | tee -a "$DIAG_LOG"
echo "User: $(whoami)" | tee -a "$DIAG_LOG"
echo "Working Directory: $(pwd)" | tee -a "$DIAG_LOG"
echo "" | tee -a "$DIAG_LOG"

# System Information
echo "=== System Information ===" | tee -a "$DIAG_LOG"
echo "OS: $(cat /etc/os-release | grep PRETTY_NAME)" | tee -a "$DIAG_LOG"
echo "Architecture: $(uname -m)" | tee -a "$DIAG_LOG"
echo "Kernel: $(uname -r)" | tee -a "$DIAG_LOG"
echo "Memory: $(free -h | grep Mem)" | tee -a "$DIAG_LOG"
echo "Disk Space: $(df -h / | tail -1)" | tee -a "$DIAG_LOG"
echo "" | tee -a "$DIAG_LOG"

# Python Environment
echo "=== Python Environment ===" | tee -a "$DIAG_LOG"
python --version 2>&1 | tee -a "$DIAG_LOG"
echo "Python Path: $(which python)" | tee -a "$DIAG_LOG"
echo "Pip Version: $(pip --version)" | tee -a "$DIAG_LOG"
echo "Installed Packages:" | tee -a "$DIAG_LOG"
pip list | grep -E "(evennia|django)" | tee -a "$DIAG_LOG"
echo "" | tee -a "$DIAG_LOG"

# Try to import Evennia
echo "=== Evennia Check ===" | tee -a "$DIAG_LOG"
python -c "
try:
    import evennia
    print(f'✓ Evennia imported successfully: {evennia.__version__}')
    print(f'  Location: {evennia.__file__}')
except ImportError as e:
    print(f'✗ Evennia import failed: {e}')
except Exception as e:
    print(f'✗ Evennia error: {e}')
" 2>&1 | tee -a "$DIAG_LOG"
echo "" | tee -a "$DIAG_LOG"

# Rust Environment
echo "=== Rust Environment ===" | tee -a "$DIAG_LOG"
rustc --version 2>&1 | tee -a "$DIAG_LOG" || echo "✗ Rust not found" | tee -a "$DIAG_LOG"
cargo --version 2>&1 | tee -a "$DIAG_LOG" || echo "✗ Cargo not found" | tee -a "$DIAG_LOG"
echo "" | tee -a "$DIAG_LOG"

# BlightMUD Check
echo "=== BlightMUD Check ===" | tee -a "$DIAG_LOG"
if command -v blightmud &> /dev/null; then
    echo "✓ BlightMUD found: $(which blightmud)" | tee -a "$DIAG_LOG"
    blightmud --version 2>&1 | tee -a "$DIAG_LOG" || echo "BlightMUD version check failed" | tee -a "$DIAG_LOG"
    echo "BlightMUD config directory: ~/.config/blightmud" | tee -a "$DIAG_LOG"
    ls -la ~/.config/blightmud/ 2>&1 | tee -a "$DIAG_LOG" || echo "BlightMUD config not found" | tee -a "$DIAG_LOG"
else
    echo "✗ BlightMUD not found in PATH" | tee -a "$DIAG_LOG"
fi
echo "" | tee -a "$DIAG_LOG"

# Network and Ports
echo "=== Network Configuration ===" | tee -a "$DIAG_LOG"
echo "Listening ports:" | tee -a "$DIAG_LOG"
netstat -tlnp 2>/dev/null | grep -E ":(4000|4001|4002|4005)" | tee -a "$DIAG_LOG" || echo "No Evennia ports listening" | tee -a "$DIAG_LOG"
echo "" | tee -a "$DIAG_LOG"

# Git Configuration
echo "=== Git Configuration ===" | tee -a "$DIAG_LOG"
git --version | tee -a "$DIAG_LOG"
echo "Git user: $(git config --global user.name) <$(git config --global user.email)>" | tee -a "$DIAG_LOG"
echo "" | tee -a "$DIAG_LOG"

# Workspace Structure
echo "=== Workspace Structure ===" | tee -a "$DIAG_LOG"
echo "Workspace contents:" | tee -a "$DIAG_LOG"
ls -la ~/workspace/ 2>&1 | tee -a "$DIAG_LOG" || echo "Workspace directory not found" | tee -a "$DIAG_LOG"

if [ -d ~/workspace/gelatinous ]; then
    echo "" | tee -a "$DIAG_LOG"
    echo "Gelatinous project structure:" | tee -a "$DIAG_LOG"
    ls -la ~/workspace/gelatinous/ | head -20 | tee -a "$DIAG_LOG"
    
    if [ -f ~/workspace/gelatinous/evennia.db ]; then
        echo "✓ Evennia database found" | tee -a "$DIAG_LOG"
    else
        echo "⚠ Evennia database not found" | tee -a "$DIAG_LOG"
    fi
else
    echo "✗ Gelatinous project not found" | tee -a "$DIAG_LOG"
fi
echo "" | tee -a "$DIAG_LOG"

# Environment Variables
echo "=== Environment Variables ===" | tee -a "$DIAG_LOG"
echo "EVENNIA_SETTINGS_MODULE: ${EVENNIA_SETTINGS_MODULE:-'not set'}" | tee -a "$DIAG_LOG"
echo "PYTHONPATH: ${PYTHONPATH:-'not set'}" | tee -a "$DIAG_LOG"
echo "PATH: $PATH" | tee -a "$DIAG_LOG"
echo "" | tee -a "$DIAG_LOG"

# Setup Logs
echo "=== Setup Logs ===" | tee -a "$DIAG_LOG"
if [ -d "$LOG_DIR" ]; then
    echo "Available logs:" | tee -a "$DIAG_LOG"
    ls -la "$LOG_DIR"/*.log 2>/dev/null | tee -a "$DIAG_LOG" || echo "No log files found" | tee -a "$DIAG_LOG"
    
    # Show last few lines of setup log if it exists
    if [ -f "$LOG_DIR/setup.log" ]; then
        echo "" | tee -a "$DIAG_LOG"
        echo "Last 10 lines of setup.log:" | tee -a "$DIAG_LOG"
        tail -10 "$LOG_DIR/setup.log" | tee -a "$DIAG_LOG"
    fi
else
    echo "Log directory not found" | tee -a "$DIAG_LOG"
fi
echo "" | tee -a "$DIAG_LOG"

# Process Information
echo "=== Running Processes ===" | tee -a "$DIAG_LOG"
echo "Python processes:" | tee -a "$DIAG_LOG"
ps aux | grep python | grep -v grep | tee -a "$DIAG_LOG" || echo "No Python processes found" | tee -a "$DIAG_LOG"
echo "" | tee -a "$DIAG_LOG"

# Final Summary
echo "=== Diagnostic Summary ===" | tee -a "$DIAG_LOG"
echo "Diagnostic log saved to: $DIAG_LOG" | tee -a "$DIAG_LOG"
echo "" | tee -a "$DIAG_LOG"

echo "Troubleshooting suggestions:" | tee -a "$DIAG_LOG"
if ! command -v blightmud &> /dev/null; then
    echo "- BlightMUD not found: Container build may have failed" | tee -a "$DIAG_LOG"
fi

if ! python -c "import evennia" 2>/dev/null; then
    echo "- Evennia not importable: Try 'pip install --user evennia'" | tee -a "$DIAG_LOG"
fi

if [ ! -d ~/workspace/gelatinous ]; then
    echo "- Gelatinous not cloned: Try running setup.sh manually" | tee -a "$DIAG_LOG"
fi

echo "" | tee -a "$DIAG_LOG"
echo "For support, share this diagnostic log!" | tee -a "$DIAG_LOG"
echo "=== End Diagnostics ===" | tee -a "$DIAG_LOG"