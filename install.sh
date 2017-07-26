#!/usr/bin/env bash

# What does this script ?
#
# Creates the files:
#    ~/.fonts/icons-in-terminal.ttf
#    ~/.config/fontconfig/conf.d/30-icons.conf
#
# Creates the directory:
#    ~/.local/share/icons-in-terminal
# or $XDG_DATA_HOME/icons-in-terminal (if $XDG_DATA_HOME is set)
#
# Run the command:
# fc-cache

source ./scripts/colors.sh

set -xe

mkdir -p ~/.fonts
cp ./build/icons-in-terminal.ttf ~/.fonts/
mkdir -p ~/.config/fontconfig/conf.d
cp ./sample/icons.conf ~/.config/fontconfig/conf.d/30-icons.conf
./scripts/generate_fontconfig.sh > ~/.config/fontconfig/conf.d/30-icons.conf
fc-cache -fvr --really-force ~/.fonts

DATA="${HOME}/.local/share"
if [ -n "$XDG_DATA_HOME" ]; then
    DATA=$XDG_DATA_HOME
fi
DATA="${DATA}/icons-in-terminal/"
mkdir -p $DATA
cp ./build/* $DATA

set +xe

#echo -e "\nBuilt files copied in $DATA (don't delete them, others programs may need them)"
echo -e "\n${YELLOW}Recommended additional step:"
echo "Edit ~/.config/fontconfig/conf.d/30-icons.conf"
echo "Check that the font(s) you are using in your terminal(s) is listed and remove all the others lines"
echo -e "\n${NORMAL}Font successfully installed. Now start a new terminal and run print_icons.sh :)"
