#!/bin/bash

set -xe
rm -rf ./build/
mkdir -p ./build
./scripts/generate_font.py ./config.json > ./build/mapping.txt
./scripts/inte_fish.sh > ./build/icons.fish
chmod +x ./build/icons.fish
mv icons-in-terminal.ttf ./build/
set +xe
echo -e "\nEverything seems good, now you can run install.sh"
