# DOOM on Braiins Forge Deck

Run the classic DOOM on your Braiins Forge Deck! This project is based on the excellent [fbDOOM](https://github.com/maximevince/fbDOOM) with custom patches for the Deck's STM32MP1 display hardware.

## What You Need

- **Braiins Forge Deck**
- **USB-C PD Power Adapter**
- **USB-C Hub with PD Support**
- **USB Keyboard**
- **DOOM WAD file** (game data)

## Quick Start

### 1. Download Pre-compiled Files

Download the latest release zip (containing `fbdoom` binary and `doom.wad`) from the [releases page](https://github.com/BraiinsForge/deck-fbdoom/releases/latest).

### 2. Access Your Deck via SSH

```bash
ssh root@<deck-ip>  # Use the admin password you set during setup
```

### 3. Stop the Deck Application

```bash
service bmc stop
```

### 4. Extract and Copy Files to Your Deck

```bash
unzip deck-fbdoom.zip
scp fbdoom doom.wad root@<deck-ip>:/root/
```

### 5. Run DOOM!

```bash
ssh root@<deck-ip>
chmod +x fbdoom
./fbdoom -iwad doom.wad
```

## Getting DOOM WAD Files

A DOOM WAD file is included in the `game_files/` directory of this repository.

## Multiplayer

Play DOOM with multiple Decks on the same network!

### Starting a Server (Host)

On the Deck that will host the game:

```bash
./fbdoom -server -nodes 2 -iwad doom.wad
```

- `-server` - Start as the game server (this player also plays)
- `-nodes 2` - Wait for 2 players before starting (adjust for more players)

### Joining a Game (Client)

On other Decks, connect to the server's IP address:

```bash
./fbdoom -connect <server-ip> -iwad doom.wad
```

For example:
```bash
./fbdoom -connect 192.168.1.241 -iwad doom.wad
```

### Multiplayer Tips

- All players must use the same WAD file
- The server player sets game options
- The game starts automatically when the expected number of players join

## Building from Source

Want to compile fbDOOM yourself instead of using the pre-built binary? Check out [BUILD.md](BUILD.md) for complete instructions.

## License

DOOM source code is licensed under the GNU GPL. See the original fbDOOM repository for details.
