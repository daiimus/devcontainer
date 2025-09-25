# Evennia Development Container

A clean, simple GitHub Codespaces devcontainer for developing [Evennia](https://github.com/evennia/evennia) MUD games.

## Features

- 🐍 **Python 3.11** with Evennia 5.0.1 pre-installed
- 🎮 **BlightMUD client** - Latest version installed from official .deb package
- 🌐 **Port forwarding** - Evennia servers (4000, 4005) ready to use
- ⚡ **Fast startup** - Minimal, reliable configuration

## Quick Start

### Using GitHub Codespaces

1. **Create a Codespace from this repository**
2. **Wait for container to build** (2-3 minutes)
3. **Start developing immediately:**
   ```bash
   # Verify both tools are installed
   evennia --version
   blightmud --version
   
   # Create a new game
   evennia --init mygame
   cd mygame
   evennia migrate
   evennia start
   
   # In another terminal, connect with BlightMUD
   blightmud
   # Then in BlightMUD: connect localhost 4000
   ```

### Using in Your Own Repository

Copy the `.devcontainer` folder to your repository root, then rebuild your container.

## What's Included

- **Evennia 5.0.1** - Complete MUD framework
- **BlightMUD 5.3.1** - Terminal MUD client (automatically installed from official .deb)
- **Python 3.11** - Latest stable Python
- **Basic dev tools** - Git, curl, wget, etc. via devcontainer features
- **VS Code Python extension** - For development support

## Ports

Automatically forwarded ports:
- **4000** - Telnet game server
- **4005** - Web client interface

## File Structure

```
.devcontainer/
├── Dockerfile          # Minimal Python + Evennia setup
└── devcontainer.json   # Simple container configuration
```

## Why This Works

This container focuses on **simplicity and reliability**:
- No complex post-creation scripts
- No project-specific assumptions  
- No unnecessary dependencies
- Clean, minimal configuration

Perfect for getting started with Evennia development quickly!
