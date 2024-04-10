#!/bin/sh

# Based CLI """Music Player""" (can also be used for videos)
# Requires mpv and fzf.

mode="fuzzy"
multi_select=""
loop=""
playlist_extension="m3u"
defaultDir=""

show_help() {
  echo -e "Usage: play [-h -d -l -m -p -pe ] [args] [/media/directory]\n"
  echo -e "Flags:"
  echo "  -h:     Display this message."
  echo "  -d:     Searches by directories."
  echo "  -l:     Enables looping."
  echo "  -m:     Enables multiple selections using Tab."
  echo "  -p:     Searches by file extension."
  echo "  -e:     Specify what file extension to use. (Defaults to m3u)"
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
      playlist_extension="$OPTARG"
      ;;
    \?)
      show_help
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

dirs_mode () {
  if [ -n "$multi_select" ]; then
    # Create a temporary playlist file.
    playlist=$(mktemp "$defaultDir"/.temp_playlist_XXXXXX.m3u)

    # Select directories and echo all non-playlist files to temp playlist.
    find $(fzf $multi_select) -type f ! -name "*.$playlist_extension" > "$playlist"

    # Ensure playlist is non-empty.
    if [ -s "$playlist" ]; then
      mpv "$playlist" $loop
    else
      echo "Error: File(s) not found. How did this even happen?"
      exit 1
    fi

    rm "$playlist"
  else
    # Create a temporary playlist file.
    playlist=$(mktemp "$defaultDir"/.temp_playlist_XXXXXX.m3u)

    # Select directory and echo all non-playlist files to temp playlist.
    find $(fzf) -type f ! -name "*.$playlist_extension" > "$playlist"

    # Ensure playlist is non-empty.
    if [ -s "$playlist" ]; then
      mpv "$playlist" $loop
    else
      echo "Error: File not found. How did this even happen?"
      exit 1
    fi

    rm "$playlist"
  fi
}

multi_select () {
  if [ -n "$multi_select" ]; then
    # Create a temporary playlist file.
    playlist=$(mktemp "$defaultDir"/.temp_playlist_XXXXXX.m3u)

    # Echo selection to playlist.
    fzf $multi_select > "$playlist"

    # Ensure playlist is non-empty.
    if [ -s "$playlist" ]; then
      mpv "$playlist" $loop
    else
      echo "Error: File(s) not found. How did this even happen?"
      exit 1
    fi
    rm "$playlist"
  else
    if [ "$mode" == "fuzzy" ]; then
      mpv $(fzf) $loop
    else
      fzf | while read -r line; do mpv "$line" $loop; done
    fi
  fi
}

mode_select () {
  case $mode in
    dirs)
      find * -type d -print | dirs_mode
      ;;
    playlist)
      find * -name "*.$playlist_extension" | multi_select
      ;;
    fuzzy)
      multi_select
      ;;
  esac
}

if [ -n "$1" ]; then # Checks for args.
  if [ -d "$1" ]; then # Checks if the arg is an existing directory.
    cd "$1" #|| exit
    defaultDir="$1"
    mode_select
  else
    echo "Error: Specified directory '$1' not found."
    exit 1
  fi
else
  for dir in "$HOME"/[mM]usic; do
    if [ -d "$dir" ]; then
      cd "$dir" #|| exit
      defaultDir="$dir"
      mode_select
      exit
    fi
  done
  echo "Error: No music directory found or specified."
  exit 1
fi
