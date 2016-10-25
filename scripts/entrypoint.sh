#!/usr/bin/env bash
# This script executes a busy wait in the base image, this is overridden in the specializations
# Trap so that the container is exited when docker engine requests
trap 'exit 0' SIGTERM
# Restart routine for php in container
while true; do
    sleep 10
done