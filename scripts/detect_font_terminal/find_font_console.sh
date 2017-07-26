#!/usr/bin/env bash

#Useless, consoles don't support font fallback

find() {
    grep -i "fontface" $1 | cut -d '=' -f 2
}

FILE_CONFIG=/etc/default/console-setup

if [ -e $FILE_CONFIG -a -r $FILE_CONFIG  ];then
    find "$FILE_CONFIG"
fi
