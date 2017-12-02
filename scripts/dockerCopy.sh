#! /bin/bash

# used to copy a file to the desired docker container

fileToCopy="$1"
containerId=$(sudo docker container list | tail -n 1 | awk '{print $1}')

sudo docker cp "$fileToCopy" "$containerId":/tmp