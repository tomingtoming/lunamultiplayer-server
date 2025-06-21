# LunaMultiplayer Server Docker

Docker setup for [LunaMultiplayer](https://github.com/LunaMultiplayer/LunaMultiplayer) server - a multiplayer mod for Kerbal Space Program.

## Features

- Easy deployment with Docker and docker-compose
- Persistent data storage for game saves and configuration
- Automatic restart on failure
- Based on Ubuntu 20.04 with .NET 5.0 runtime

## Requirements

- Docker
- Docker Compose

## Quick Start

1. Clone this repository:
```bash
git clone https://github.com/tomingtoming/lunamultiplayer-server.git
cd lunamultiplayer-server
```

2. Start the server:
```bash
docker-compose up -d
```

3. Check server logs:
```bash
docker-compose logs -f
```

## Configuration

The server uses the following ports:
- **8800/UDP**: Game communication port
- **8801/TCP**: Server administration port

### Data Persistence

- `./server-data/`: Universe save data
- `./server-config/`: Server configuration files

These directories are automatically created and mounted as volumes.

## Server Management

### Start server
```bash
docker-compose up -d
```

### Stop server
```bash
docker-compose down
```

### View logs
```bash
docker-compose logs -f
```

### Restart server
```bash
docker-compose restart
```

## Building from Source

If you want to build the Docker image yourself:

```bash
docker build -t lunamultiplayer-server .
```

## Environment Variables

- `DOTNET_CLI_TELEMETRY_OPTOUT=1`: Disables .NET telemetry

## Connecting to the Server

1. Install [LunaMultiplayer client mod](https://github.com/LunaMultiplayer/LunaMultiplayer/releases) in your KSP installation
2. Launch KSP with the mod installed
3. In the multiplayer menu, add your server:
   - Server Name: Your choice
   - Address: Your server IP
   - Port: 8800

## Troubleshooting

### Server won't start
- Check if ports 8800/8801 are already in use
- Review logs with `docker-compose logs`

### Connection issues
- Ensure firewall allows UDP port 8800 and TCP port 8801
- Verify server is running with `docker-compose ps`

## License

This Docker setup is provided as-is. LunaMultiplayer is licensed under its own terms - see the [official repository](https://github.com/LunaMultiplayer/LunaMultiplayer) for details.

## Contributing

Pull requests are welcome! Please feel free to submit issues or improvements.