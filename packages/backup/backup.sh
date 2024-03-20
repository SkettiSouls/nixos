#!/bin/sh
rsync -vrl ~/bin ~/Documents ~/Music ~/Pictures ~/Desktop ~/Videos ~/Vesktop ~/Projects ~/Downloads ~/.wine ~/.config ~/.bashrc /run/media/skettisouls/backup/
mkdir -pv /run/media/skettisouls/backup/.local/share
rsync -vrl ~/.local/share/applications ~/.local/share/fonts ~/.local/share/lutris /run/media/skettisouls/backup/.local/share
