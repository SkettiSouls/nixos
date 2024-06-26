#!/usr/bin/env bash

### Music Filename Formatter ###

# Create a temporary file with all file names.
tmp=$(mktemp /tmp/temp_list_XXXXXX.txt)
echo "$(find * -type f)" > "$tmp"

# Loop until every line of the tmp file is read.
while read -r line; do
  # Format file name.
  origin="$line"
  pass1=$(echo "$origin" | sed 's/\ \[.*\]//g') # Remove ' [anything in here]'.
  pass2=$(echo "$pass1" | sed 's/[()]//g') # Remove any parenthesis.
  pass3=${pass2//[' ']/_} # Replace any spaces with underscores.
  pass4=$(echo "${pass3,,}") # Replace all caps with lowercase characters.

  # Display each stage of the file name for confirmation.
  echo -e "Original:\n$origin\n"
  echo -e "1st pass:\n$pass1\n"
  echo -e "2nd pass:\n$pass2\n"
  echo -e "3rd pass:\n$pass3\n"
  echo -e "4th pass:\n$pass4\n"

  # Require user confirmation.
  echo "Confirm? (y/n/a)"

  # Prevent asking for confirmation after agreeing to all ('a').
  if [ -z "$skip" ]; then
    read confirm < /dev/tty
  fi

  # Parse confirmation/denial.
  if [ "$confirm" == "y" ]; then
    echo -e "Confirmed.\n"
    mv "$origin" "$pass4"
  elif [ "$confirm" == "n" ]; then
    echo -e "Denied.\n"
  elif [ "$confirm" == "a" ]; then
    # Invalidates the confirmation `if` statement and accepts all changes.
    skip="on"
    confirm="y"
  else
    echo "Confirmation required."
    rm "$tmp"
    exit 1
  fi
done < "$tmp"
rm "$tmp"
