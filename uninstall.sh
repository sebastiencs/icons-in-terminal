#!/usr/bin/env bash

DATA="${XDG_DATA_HOME:-${HOME}/.local/share}/icons-in-terminal/"

set -xe

rm -f ~/.config/fontconfig/conf.d/30-icons.conf
rm -f ~/.fonts/icons-in-terminal.ttf
rm -rf "$DATA"

fc-cache -fvr --really-force > /dev/null

set +xe

echo "icons-in-terminal uninstalled. Close all your terminal windows."
