# Evennia Development Container

Everything you need to start building a multiplayer text game with [Evennia](https://www.evennia.com), running in your browser via GitHub Codespaces. No local setup required.

Evennia and all of its dependencies are pre-installed. Every container rebuild automatically pulls the latest stable versions — nothing to maintain.

## Quick Start

### 1. Launch a Codespace

Click the green **Code** button at the top of this repository, select the **Codespaces** tab, and click **Create codespace on main**. A VS Code editor will open in your browser. Wait for the container to finish building (~2-3 minutes).

> You can also copy the `.devcontainer/` folder into your own repository to use this setup in any project.

### 2. Create Your Game

Open the terminal in VS Code (`` Ctrl+` ``) and run:

```bash
evennia --init mygame
cd mygame
evennia migrate
```

`evennia --init` creates a new game folder with all the starter files you need. `evennia migrate` sets up the database — you only need to run this once.

### 3. Start the Server

```bash
evennia start
```

You'll be asked to create a **superuser** account (pick any username and password). This will be your admin character with full permissions in the game.

### 4. Play

In the Codespaces **Ports** panel (next to the Terminal panel at the bottom), find port **4001** and click the globe icon to open it in a new tab. This is Evennia's built-in webclient. Log in with the account you just created.

You can also connect with any MUD client (Mudlet, TinTin++, etc.) using port **4000**.

### 5. Try the Tutorial World

Once logged in, type:

```
batchcommand tutorial_world.build
```

This installs a small built-in adventure you can explore to see what Evennia can do. Type `tutorial` for instructions once it's loaded.

## Useful Commands

### Terminal (outside the game)

```bash
evennia start          # Start the server
evennia restart        # Restart without disconnecting players
evennia stop           # Shut down the server
evennia start -l       # Start and tail the server log
evennia -l             # Tail the log of a running server
```

### In-Game (as superuser)

```
help                   # List all available commands
look                   # Look around the current room
create bag             # Create a new object called "bag"
dig north = kitchen    # Create a new room and link it
examine me             # See detailed info about your character
py 1 + 1              # Run Python code directly in-game
reload                 # Reload the server after code changes
```

## Game Directory Structure

After `evennia --init mygame`, your game folder looks like this:

```
mygame/
├── commands/          # Your custom commands
├── server/
│   ├── conf/
│   │   └── settings.py   # Your game settings (add overrides here)
│   └── logs/              # Server logs
├── typeclasses/       # Custom object, character, and room types
├── web/               # Web interface customization
└── world/             # World-building scripts and data
```

You build your game by editing the files in this folder. When you change code, type `reload` in-game or run `evennia reload` from the terminal to pick up your changes without restarting the server.

See the [Game Dir Overview](https://www.evennia.com/docs/latest/Howtos/Beginner-Tutorial/Part1/Beginner-Tutorial-Gamedir-Overview.html) for a detailed walkthrough of each folder.

## Ports

| Port | What It Does |
|------|-------------|
| 4000 | Telnet — for connecting with traditional MUD clients |
| 4001 | Web — Evennia's webclient and web admin interface |
| 4002 | WebSocket — used internally by the webclient |

## Learn More

- [Beginner Tutorial](https://www.evennia.com/docs/latest/Howtos/Beginner-Tutorial/Beginner-Tutorial-Overview.html) — a multi-part guided walkthrough that ends with a playable game
- [Evennia Documentation](https://www.evennia.com/docs/latest/index.html) — full reference for all features
- [Discord](https://discord.gg/AJJpcRUhtF) — get help from the community
- [Discussion Forums](https://github.com/evennia/evennia/discussions) — Q&A and announcements
