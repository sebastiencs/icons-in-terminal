#!/usr/bin/env bash

gsettings get org.gnome.desktop.interface monospace-font-name | sed -e "s/^'//" -e "s/'\$//" | rev | cut -d ' ' -f 2- | rev
