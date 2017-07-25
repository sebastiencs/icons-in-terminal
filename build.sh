#!/usr/bin/env bash

set -xe
rm -rf ./build/
mkdir -p ./build
./scripts/generate_font.py ./config.json > ./build/mapping.txt
./scripts/inte_fish.sh > ./build/icons.fish
./scripts/inte_bash.sh > ./build/icons_bash.sh
./scripts/inte_bash_export.sh > ./build/icons_bash_export.sh
./scripts/inte_without_codepoint.sh > ./build/icons_bash_without_codepoint.sh
./scripts/inte_emacs.sh > ./build/icons-in-terminal.el
./scripts/inte_c_header.sh > ./build/icons-in-terminal.h
chmod +x ./build/icons.fish
chmod +x ./build/icons_bash.sh
mv icons-in-terminal.ttf ./build/
set +xe
echo -e "\nEverything seems good, now you can run install.sh"
