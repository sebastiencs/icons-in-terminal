#!/usr/bin/env bash

//RUNNER=./FontForge-2020-11-07-21ad4a1-x86_64.AppImage;

set -xe
rm -rf ./build/
mkdir -p ./build

# If we don't have FontForge dependency, fetch it.
if ! test -x ./FontForge.AppImage; then
	echo "Downloading the latest FontForge AppImage from Github...";
	# Download the latest fontforge. It comes bundled with Python 3.
	curl -s https://api.github.com/repos/fontforge/fontforge/releases |
		grep -m 1 "https://.*\.AppImage" | sed -E 's/.*(https:.*\.AppImage).*/\1/' |
		xargs curl -L --output FontForge.AppImage;
	# Make sure it's executable
	chmod +x ./FontForge.AppImage;
fi;

# Use the fontforge binary to execute our generator script.
# NOTE:
#   There are limitations to this. Due to how AppImages are packaged,
#   the builtin python executable will always be started in a temporary
#   environment because it's assumed that said binary will be self-contained
#   and not need access to the CWD at all. (At least I think, that's what
#   I gathered from my time experimenting with it trying to get this to work)
#   So we can only inject a script to load from STDIN which removes our ability
#   to append any command line arguments. To work around this, I added
cat ./scripts/generate_font.py |
	sed "1 i\\argv = [\"$PWD\", \"/config.json\"]" |
	./FontForge.AppImage -lang=py -script > ./build/mapping.txt;

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
