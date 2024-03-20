#!/bin/sh

# Requires mpv and fzf.

mode="fuzzy"
multi_select=""
loop=""
playlist_extension="m3u"

show_help() {
  echo -e "Usage: play [-h -d -l -m -p -pe ] [args] [/media/directory]\n"
  echo -e "Flags:"
  echo "  -h:     Display this message."
  echo "  -d:     Searches by directories."
  echo "  -l:     Enables looping (-lm is funky)."
  echo "  -m:     Enables multiple selections using Tab."
  echo "  -p:     Searches by playlist using m3u files."
  echo "  -pe:    Overrides the file extension used by -p."
}

while getopts "hdlmpe:" opt; do
  case ${opt} in
    h)
      show_help
      exit 1
      ;;
    d)
      mode="dirs"
      ;;
    l)
      loop="--loop-playlist"
      ;;
    m)
      multi_select="-m"
      ;;
    p)
      mode="playlist"
      ;;
    e)
      if [ "$mode" == "playlist" ]; then
	playlist_extension="$OPTARG"
      else 
	show_help
        exit 1
      fi
      ;;
    \?)
      show_help
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

mode_select () {
  case $mode in
    dirs)
      find * -type d -print | fzf $multi_select | while read -r line; do mpv "$line" $loop; done
      ;;
    playlist)
      find * -name "*.$playlist_extension" | fzf $multi_select | while read -r line; do mpv "$line" $loop; done
      ;;
    fuzzy)
      fzf $multi_select | while read -r line; do mpv "$line" $loop; done
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
