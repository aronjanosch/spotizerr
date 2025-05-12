# Spotizerr Development Environment

This project includes a development container configuration for Visual Studio Code, which sets up a complete development environment with all dependencies for the Spotizerr application.

## Prerequisites

1. [Visual Studio Code](https://code.visualstudio.com/)
2. [Docker](https://www.docker.com/products/docker-desktop)
3. [VS Code Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Getting Started

1. Clone this repository
2. Open the repository in Visual Studio Code
3. When prompted to "Reopen in Container", click "Reopen in Container". Alternatively, you can:
   - Click the green button in the bottom-left corner of VS Code
   - Select "Dev Containers: Reopen in Container" from the command palette (F1)

VS Code will build the development container and set up all dependencies. This may take a few minutes the first time.

## Development

### Running the Application

There are multiple ways to run the application during development:

#### Option 1: Using the development script

Run the included dev-server.sh script:

```bash
bash .devcontainer/dev-server.sh
```

This will start both a Celery worker and a Flask development server with hot reloading.

#### Option 2: Using VSCode's debugger

1. Switch to the "Run and Debug" panel in VS Code
2. Select "Python: Flask" from the dropdown
3. Click the green play button to start the app with debugging capabilities

### Project Structure

- `/routes`: API endpoints and route handlers
- `/routes/utils`: Utility functions and Celery task definitions
- `/static`: Frontend static files (JS, CSS)
- `/templates`: HTML templates
- `/creds`: Credentials storage (mounted volume)
- `/config`: Configuration files (mounted volume)
- `/downloads`: Downloaded music files (mounted volume)
- `/logs`: Application logs (mounted volume)

### Important Configuration

The devcontainer is configured with:

- Redis server accessible at redis:6379
- Flask application running on port 7171
- Explicit filter disabled by default
- Python 3.12
- Dev Containers features for Python tools

### Volumes

The development container uses named volumes for persistent data:

- `spotizerr-app-creds`: Credentials storage
- `spotizerr-app-config`: Configuration files
- `spotizerr-app-downloads`: Downloaded music files
- `spotizerr-app-logs`: Application logs
- `spotizerr-redis-data`: Redis data

These volumes ensure your data persists between container rebuilds.

## Customization

If you need to modify the development environment:

1. Edit `.devcontainer/Dockerfile` to change the container configuration
2. Edit `.devcontainer/docker-compose.yml` to change service configuration
3. Edit `.devcontainer/devcontainer.json` to change VS Code settings and extensions
4. Rebuild the container using the "Dev Containers: Rebuild Container" command

### Adding More Tools

You can add more development tools by:

1. Adding Dev Container features in the `features` section of `devcontainer.json`
2. Installing additional packages in the Dockerfile
3. Adding VS Code extensions in the `customizations.vscode.extensions` section

## Troubleshooting

### Redis Connection Issues

If you experience Redis connection issues:
- Check that the Redis service has started properly using `docker ps`
- Verify network connectivity between containers with: `ping redis` from the app container
- Ensure environment variables match the Redis configuration in `docker-compose.yml`
- Try manually connecting to Redis: `redis-cli -h redis -p 6379 -a devpassword`

### Application Not Starting

If the application doesn't start:
- Check logs with `cat /workspace/logs/celery.log` for Celery issues
- Verify Redis is running with `redis-cli -h redis ping`
- Ensure environment variables are correctly set
- Try starting components manually:
  ```bash
  # Start Celery worker
  celery -A routes.utils.celery_tasks.celery_app worker --loglevel=info
  
  # Start Flask app in a different terminal
  FLASK_APP=app.py FLASK_ENV=development flask run --host=0.0.0.0 --port=7171
  ```

### Container Rebuilding

If you need to completely rebuild the environment:
1. Open the command palette (F1)
2. Select "Dev Containers: Rebuild Container"

This will recreate the container with any changes you've made to the configuration files.