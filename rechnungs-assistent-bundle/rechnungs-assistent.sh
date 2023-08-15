#!/bin/bash

# if /app/bin is present change directory to it (because then we are in flatpak)
if [ -d "/app/bin" ]; then
    cd /app/bin
fi

# Check if any arguments were passed
if [ $# -eq 0 ]; then
    echo "Starting frontend..."
    python3 runner.py &
    ./invoice
    exit 0
fi

# Start generator with arguments
echo "Starting generator..."
python3 generator.py "$@"
