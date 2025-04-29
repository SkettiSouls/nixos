#!/usr/bin/env bash

### Nixos Rebuild Script ###

arg="test"
desktop="${XDG_CURRENT_DESKTOP,,}"
reloadWM=""
input="$1"
flagTest="${input//[!-]/}"

if [ "$desktop" == "hyprland" ]; then
  reloadWM="hyprctl reload"
fi

if [ -n "$1" ]; then
  if [ "$flagTest" == "--" ]; then
    flags="$@"
    # echo "sudo nixos-rebuild $arg $flags && $reloadWM"
    sudo nixos-rebuild "$arg" "$flags"
    $reloadWM
  else
    arg="$@"
    # echo "sudo nixos-rebuild $arg && $reloadWM"
    sudo nixos-rebuild $arg
    $reloadWM
  fi
else
  # echo "sudo nixos-rebuild $arg && $reloadWM"
  sudo nixos-rebuild $arg
  $reloadWM
fi
