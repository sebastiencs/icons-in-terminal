#!/bin/bash

grep '<family>YOUR_TERMINAL_FONT</family>' ./sample/icons.conf > /dev/null
if [ $? -eq 0 ]
then
    echo "Please change the text YOUR_TERMINAL_FONT in sample/icons.conf."
    echo "You should replace 'YOUR_TERMINAL_FONT' to the name of your font, the one you're using in your terminal."
    echo "For example: Droid Sans Mono"
    exit 1
fi

set -xe
mkdir -p ~/.fonts
cp ./build/icons-in-terminal.ttf ~/.fonts/
mkdir -p ~/.config/fontconfig/conf.d
cp ./sample/icons.conf ~/.config/fontconfig/conf.d/
fc-cache -fvr --really-force ~/.fonts
set +xe

echo "Font successfully installed. Now start a new terminal and run print_icons.sh :)"
