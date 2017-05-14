#!/bin/bash

set -xe

mkdir -p ~/.fonts
cp ./build/icons-in-terminal.ttf ~/.fonts/
mkdir -p ~/.config/fontconfig/conf.d
cp ./sample/icons.conf ~/.config/fontconfig/conf.d/20-icons.conf
./scripts/generate_fontconfig.sh > ~/.config/fontconfig/conf.d/20-icons.conf
fc-cache -fvr --really-force ~/.fonts

DATA="${HOME}/.local/share"
if [ -n "$XDG_DATA_HOME" ]; then
    DATA=$XDG_DATA_HOME
fi
DATA="${DATA}/icons-in-terminal/"
mkdir -p $DATA
cp ./build/* $DATA

set +xe

echo -e "\nBuilt files copied in $DATA (just to keep them safe)"
echo "Font successfully installed. Now start a new terminal and run print_icons.sh :)"
