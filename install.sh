#!/bin/bash

swift build

source_file=".build/debug/skibidipop"
destination_directory="/usr/local/bin"

if [ ! -e "$source_file" ]; then
    echo "Error: executable does not exist"
    exit 1
fi

if [ ! -d "$destination_directory" ]; then
    echo "Error: cant find /user/local/bin. Are you on posix system?"
    exit 1
fi

sudo cp "$source_file" "$destination_directory"
echo "skibidipop installed in '$destination_directory'."
