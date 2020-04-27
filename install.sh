#!/usr/bin/env bash

#
# What does this script ?
#
# Create the files:
#    ~/.fonts/icons-in-terminal.ttf
#    ~/.config/fontconfig/conf.d/30-icons.conf
#
# Create the directory:
#    ~/.local/share/icons-in-terminal
# or $XDG_DATA_HOME/icons-in-terminal (if $XDG_DATA_HOME is set)
#
# Copy the built files in the created directory
#
# Run the command:
# fc-cache
#

source ./scripts/colors.sh

set -xe

DATA="${XDG_DATA_HOME:-${HOME}/.local/share}/icons-in-terminal/"

FONT_DIR=~/.local/share/fonts
mkdir -p $FONT_DIR
cp ./build/icons-in-terminal.ttf $FONT_DIR
mkdir -p ~/.config/fontconfig/conf.d
# Make temporary file first to prevent incomplete conf file from being used by
# fc-list inside generate_fontconfig.sh. cf) fontconfig loads conf.d/[0-9]*
TMP_CONF_FILE=~/.config/fontconfig/conf.d/tmp-30-icons.conf
CONF_FILE=~/.config/fontconfig/conf.d/30-icons.conf
./scripts/generate_fontconfig.sh > $TMP_CONF_FILE
mv $TMP_CONF_FILE $CONF_FILE
fc-cache -fvr --really-force $FONT_DIR

mkdir -p "$DATA"
cp ./build/* "$DATA"

set +xe

echo -e "\n${YELLOW}Recommended additional step:"
echo "Edit $CONF_FILE"
echo "Check that the font(s) you are using in your terminal(s) is listed and remove all the others lines"
echo -e "\n${NORMAL}Font successfully installed. Now start a new terminal and run print_icons.sh :)"
