# Spotizerr Simple Dev Environment

## Getting Started

1. Open this folder in VS Code with the Dev Containers extension installed
2. When prompted, click "Reopen in Container"
3. Wait for the container to build and start

## Running the Flask App

To run the Flask app, open a terminal in VS Code and run:

```bash
# Navigate to the workspace folder (if needed)
cd /workspace

# Run the application
python app.py
```

## Redis Connection

Redis is available at:
- Host: redis
- Port: 6379
- Password: devpassword
- URL: redis://:devpassword@redis:6379/0

You can test the Redis connection with:

```bash
redis-cli -h redis -p 6379 -a devpassword ping
```

## Available Tools

- **Python 3.12**: The development environment uses Python 3.12
- **ffmpeg**: Available for audio processing
- **Redis**: Running in a separate container

## Directory Structure

The required directories are already created in the container:
- /workspace/downloads
- /workspace/config
- /workspace/creds
- /workspace/logs