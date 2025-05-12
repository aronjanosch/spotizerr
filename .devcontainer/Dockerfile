FROM mcr.microsoft.com/devcontainers/python:3.12

# Install required system packages (ffmpeg for audio processing)
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories in the workspace folder
RUN mkdir -p /workspace/downloads /workspace/config /workspace/creds /workspace/logs \
    && chmod 777 /workspace/downloads /workspace/config /workspace/creds /workspace/logs

# Set the working directory
WORKDIR /workspace

# Expose the port for the application
EXPOSE 7171