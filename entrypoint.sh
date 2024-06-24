#!/bin/bash

# Function to wait for a process to start
function wait_for_process() {
    local max_time_wait=30
    local process_name="$1"
    local waited_sec=0
    while ! pgrep "$process_name" >/dev/null && ((waited_sec < max_time_wait)); do
        echo "Process $process_name is not running yet. Retrying in 1 second"
        echo "Waited $waited_sec seconds of $max_time_wait seconds"
        sleep 1
        ((waited_sec++))
        if ((waited_sec >= max_time_wait)); then
            return 1
        fi
    done
    return 0
}

echo "Starting supervisor"
supervisord -n >> /dev/null 2>&1 &

echo "Waiting for dockerd to be running"
wait_for_process dockerd
if [ $? -ne 0 ]; then
    echo "Error: dockerd is not running after max time"
    exit 1
else
    echo "dockerd is running"
fi

# Execute specified command
exec "$@"
