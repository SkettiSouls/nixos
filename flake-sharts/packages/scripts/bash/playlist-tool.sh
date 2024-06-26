#!/usr/bin/env bash

# Mpv playlist file maker.
# Requires fzf.

# Grab current directory name.
dirName=${PWD##*/}
dirName=${result:-/}

# Check for user input.
if [ -n "$1" ]; then
	input="$1"
else input="$dirName"
fi

# Generate playlist name based on input or dir name.
# Removes '.m3u' if provided to prevent '.m3u.m3u'.
file_name=$(echo "$input" | sed -e 's/.m3u//g')

# Select play order with fzf.
echo "$(fzf -m)" > $file_name.m3u

# Print contents of playlist file for error checking.
cat $file_name.m3u
