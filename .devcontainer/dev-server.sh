#!/bin/bash
# Start the development environment

# Colors for better readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Spotizerr development environment...${NC}"

# Check if Redis is available
echo -e "${YELLOW}Checking Redis connection...${NC}"
redis-cli -h redis -p 6379 -a devpassword ping 2>/dev/null || {
    echo -e "${RED}Error: Redis is not available. Please make sure Redis is running.${NC}"
    exit 1
}
echo -e "${GREEN}Redis is available!${NC}"

# Set environment variables
export FLASK_APP=app.py
export FLASK_ENV=development
export FLASK_DEBUG=1
export PYTHONPATH=/workspace

# Make directories if they don't exist
mkdir -p /workspace/downloads /workspace/config /workspace/creds /workspace/logs
chmod 777 /workspace/downloads /workspace/config /workspace/creds /workspace/logs

# Start Celery worker in the background
echo -e "${YELLOW}Starting Celery worker...${NC}"
celery -A routes.utils.celery_tasks.celery_app worker \
    --loglevel=info \
    --concurrency=1 \
    -Q downloads \
    --logfile=/workspace/logs/celery.log &
CELERY_PID=$!

# Wait a moment for Celery to initialize
sleep 2

# Check if Celery started successfully
if ps -p $CELERY_PID >/dev/null; then
    echo -e "${GREEN}Celery worker started with PID $CELERY_PID${NC}"
else
    echo -e "${RED}Failed to start Celery worker${NC}"
    exit 1
fi

# Create trap to ensure Celery worker is terminated when this script exits
trap "echo -e '${YELLOW}Shutting down Celery worker...${NC}'; kill -TERM $CELERY_PID; wait $CELERY_PID 2>/dev/null; echo -e '${GREEN}Development environment stopped${NC}'" EXIT

# Start Flask development server
echo -e "${YELLOW}Starting Flask development server on port 7171...${NC}"
echo -e "${GREEN}Access the application at: http://localhost:7171${NC}"
python -m flask run --host=0.0.0.0 --port=7171
