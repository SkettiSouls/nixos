#!/bin/sh

# Requires mpv and fzf.

mode="fuzzy"
multi_select=""
playlist_extension="m3u"
help_msg='echo -e Usage: play [ -d -h -m -p -pe ] [args] [/media/directory]\n-h: Display this message.\n-d: Searches by directories.\n-m: Enables multiple selections using Tab.\n-p: Searches by playlist using m3u files.\n-e: Overrides the file extension used by -p.'

while getopts "hdmpe:" opt; do
  case ${opt} in
    h)
      mode="help"
      ;;
    d)
      mode="dirs"
      ;;
    m)
      multi_select="-m"
      ;;
    p)
      mode="playlist"
      ;;
    e)
      playlist_extension="$OPTARG"
      ;;
    \?)
      mode="help"
      ;;
     esac
done
shift $((OPTIND -1))

mode_select () {
  case $mode in
    help)
      $help_msg
      exit 1
      ;;
    dirs)
      find * . -type d -print | fzf $multi_select | while read -r line; do mpv "$line"; done
      ;;
    playlist)
      find * . -name "*.$playlist_extension" | fzf $multi_select | while read -r line; do mpv "$line"; done
      ;;
    fuzzy)
      fzf $multi_select | while read -r line; do mpv "$line"; done
      ;;
  esac
}

if [ -n "$1" ]; then
  if [ -d "$1" ]; then
    cd "$1" #|| exit
    mode_select
  else
    echo "Error: Specified directory '$1' not found."
    exit 1
  fi
else
  for dir in "$HOME"/[mM]usic; do
    if [ -d "$dir" ]; then
      cd "$dir" #|| exit
      mode_select
      exit
    fi
  done
  echo "Error: No music directory found or specified."
  exit 1
fi
