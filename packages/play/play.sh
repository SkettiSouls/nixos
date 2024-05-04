#!/usr/bin/env bash

# Based CLI """Music Player""" (can also be used for videos)
# Requires mpv and fzf.

# TODO: Shuffle

mode="fuzzy"
multiSelect=""
loop=""
playlistExtension="m3u"
defaultDir=""

show_help() {
  echo -e "Usage: play [-h -d -l -m -p -pe ] [args] [/media/directory]\n"
  echo -e "Flags:"
  echo "  -h:     Display this message."
  echo "  -c:     Creates an mpv playlist file."
  echo "  -d:     Searches by directories."
  echo "  -f:     Formats filenames."
  echo "  -l:     Enables looping."
  echo "  -m:     Enables multiple selections using Tab."
  echo "  -p:     Searches by file extension."
  echo "  -e:     Specify what file extension to use. (Defaults to m3u)"
}

while getopts "hcdflmpe:" opt; do
  case ${opt} in
    h)
      show_help
      exit 1
      ;;
    c)
      mode="create"
      ;;
    d)
      mode="dirs"
      ;;
    f)
      mode="format"
      ;;
    l)
      loop="--loop-playlist"
      ;;
    m)
      multiSelect="-m"
      ;;
    p)
      mode="playlist"
      ;;
    e)
      playlistExtension="$OPTARG"
      ;;
    \?)
      show_help
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

create_playlist() {
  # Directory confirmation.
  echo "Create a playlist in $defaultDir? (y/n/f)"
  read dirConfirm < /dev/tty

  # Parse confirmation/denial.
  case $dirConfirm in
    y)
      # Grab current directory name.
      fileName=${PWD##*/}
      fileName=${fileName:-/}

      # Select play order with fzf.
      selection="$(fzf -m)"

      if [ -n "$selection" ]; then
        echo "$selection" > $fileName.m3u

        # Print contents of playlist file for error checking.
        echo "Created playlist '$fileName.m3u' with contents:"
        cat $fileName.m3u;
      else
        echo "Error: No selection made."
        exit 1
      fi
      ;;
    f)
      # Fuzzy find to the desired directory to format.
      dirName=$(find * -type d -print | fzf)
      cd "$dirName"

      # Grab current directory name.
      fileName=${PWD##*/}
      fileName=${fileName:-/}

      # Select play order with fzf.
      selection="$(fzf -m)"

      if [ -n "$selection" ]; then
        echo "$selection" > $fileName.m3u

        # Print contents of playlist file for error checking.
        echo "Created playlist '$fileName.m3u' with contents:"
        cat $fileName.m3u;
      else
        echo "Error: No selection made."
        exit 1
      fi
      ;;
    n)
      echo "Nothing to do; exiting."
      exit 1
      ;;
    *)
      echo "Error: Please confirm or deny changes."
      create_playlist
      ;;
  esac
}

dirs_mode () {
  # Create a temporary playlist file.
  playlist=$(mktemp "$defaultDir"/.temp_playlist_XXXXXX.m3u)

  # Select directories and echo all non-playlist files to temp playlist.
  find $(fzf $multiSelect) -type f ! -name "*.$playlistExtension" > "$playlist"

  # Ensure playlist is non-empty.
  if [ -s "$playlist" ]; then
    mpv "$playlist" $loop
  else
    echo "Error: File(s) not found. How did this even happen?"
    rm "$playlist"
    exit 1
  fi

  rm "$playlist"
}

format_names() {
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
}

multi_select () {
  if [ -n "$multiSelect" ]; then
    # Create a temporary playlist file.
    playlist=$(mktemp "$defaultDir"/.temp_playlist_XXXXXX.m3u)

    # Echo selection to playlist.
    fzf $multiSelect > "$playlist"

    # Ensure playlist is non-empty.
    if [ -s "$playlist" ]; then
      mpv "$playlist" $loop
    else
      echo "Error: File(s) not found. How did this even happen?"
      rm "$playlist"
      exit 1
    fi
    rm "$playlist"
  else
    if [ "$mode" == "fuzzy" ]; then
      mpv "$(fzf)" $loop
    else
      fzf | while read -r line; do mpv "$line" $loop; done
    fi
  fi
}

mode_select () {
  case $mode in
    create)
      create_playlist
      ;;
    dirs)
      find * -type d -print | dirs_mode
      ;;
    playlist)
      find * -name "*.$playlistExtension" | multi_select
      ;;
    fuzzy)
      multi_select
      ;;
    format)
      format_names
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
