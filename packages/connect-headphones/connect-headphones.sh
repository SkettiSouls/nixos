#!/usr/bin/env bash
if [ -n "$1" ]; then
  headphones="$1"

  bluetoothctl power on

  info=`bluetoothctl info "$headphones"`
  if echo "$info" | grep -q "Connected: no"; then
    bluetoothctl connect "$headphones"
  else
    echo "Headphones already connected, continuing..."
  fi
else
  echo "No MAC address provided."
  exit 1
fi
