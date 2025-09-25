# Evennia Development Devcontainer

A GitHub Codespaces devcontainer repository for developing [Evennia](https://github.com/evennia/evennia) MUD games with integrated [BlightMUD](https://github.com/blightmud/blightmud) client. This environment automatically sets up your development workspace with the [Gelatinous](https://github.com/daiimus/gelatinous) project.

## Features

- 🐍 **Python 3.11** with Evennia framework pre-installed
- 🦀 **Rust environment** with BlightMUD terminal MUD client
- 🎮 **Automatic Gelatinous setup** - your game project is cloned and configured automatically
- 🔧 **VS Code extensions** for Python and Rust development
- 🌐 **Port forwarding** for Evennia web interface and game servers
- ⚡ **Pre-configured aliases** for common development tasks

## Quick Start

### Using GitHub Codespaces

1. **Create a new Codespace:**
   - Go to [GitHub Codespaces](https://github.com/codespaces)
   - Click "New codespace"
   - Select this repository (`daiimus/devcontainer`)
   - Click "Create codespace"

2. **Wait for setup:**
   - The environment will automatically install all dependencies
   - Gelatinous will be cloned to `/workspace/gelatinous`
   - All tools will be configured and ready to use

3. **Start developing:**
   ```bash
   # Start your Evennia server
   evennia-start
   
   # Connect with BlightMUD client
   blightmud
   ```

### Manual Setup

If you want to use this devcontainer in your own repository:

1. Copy the `.devcontainer` folder to your repository root
2. Open the repository in VS Code
3. When prompted, reopen in container

## Available Commands

The setup script creates several useful aliases:

### Evennia Commands
- `evennia-start` - Start the Evennia server
- `evennia-stop` - Stop the Evennia server  
- `evennia-restart` - Restart the Evennia server
- `evennia-shell` - Open Evennia Python shell

### MUD Client
- `blightmud` or `mud` - Start BlightMUD terminal client

### Development
- Standard Git aliases (`gs`, `ga`, `gc`, `gp`, `gl`)
- File navigation aliases (`ll`, `la`, `..`, `...`)

## Ports

The following ports are automatically forwarded:

- **4000** - Evennia Web Server
- **4001** - Evennia Portal
- **4002** - Evennia Server  
- **4005** - Evennia Web Client (main web interface)

## Project Structure

After setup, your workspace will contain:

```
/workspace/
├── gelatinous/          # Your Evennia game project (auto-cloned)
└── .devcontainer/       # Container configuration
    ├── devcontainer.json
    ├── Dockerfile
    └── setup.sh
```

## Connecting to Your Game

### Local Development
1. Start your Evennia server: `evennia-start`
2. Open BlightMUD: `blightmud`
3. Connect to `localhost:4000` (or use the web client on port 4005)

### Production Connection
1. Open BlightMUD: `blightmud`
2. Connect to your production server address
3. Use the client to play while developing locally

## Customization

### BlightMUD Configuration
BlightMUD settings are stored in `/home/vscode/.config/blightmud/settings.ron`

### Adding Dependencies
- Python packages: Add to `gelatinous/requirements.txt`
- System packages: Modify `.devcontainer/Dockerfile`
- VS Code extensions: Edit `devcontainer.json`

## Troubleshooting

### Container Won't Start
- Check the logs in the terminal
- Ensure Docker is running
- Try rebuilding the container

### Evennia Server Issues
- Check the logs: `cd gelatinous && evennia log`
- Ensure migrations are applied: `evennia migrate`
- Restart the server: `evennia-restart`

### BlightMUD Issues
- Check configuration in `/home/vscode/.config/blightmud/`
- Ensure the MUD server is running and accessible
- Try connecting with telnet first: `telnet localhost 4000`

## Contributing

Feel free to submit issues and pull requests to improve this devcontainer setup!
