#!/bin/bash

# Generate a fontconfig configuration file
# See /etc/fonts/conf.d/README

readarray LIST_FONTS < <(fc-list :mono family | sort | sed "s/\\\-/-/g" | grep -v 'icons-in-terminal')
#readarray LIST_FONTS < <(fc-list : family | sort | sed "s/\\\-/-/g" | grep -v 'icons-in-terminal')

echo '<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>'

echo '  <!-- Only monospaced fonts have been listed here -->'
echo "  <!-- If your font isn't in the list, uncomment the next line and write its name -->"
echo "  <!-- <alias><family>YOUR_TERMINAL_FONT</family><default><family>icons-in-terminal</family></default></alias> -->"
for FONT_NAME in "${LIST_FONTS[@]}"
do
    FONT_NAME=`echo $FONT_NAME | tr -d '\n'`
    echo '  <alias><family>'"${FONT_NAME}"'</family><default><family>icons-in-terminal</family></default></alias>'
#    echo '  <alias><family>'"${FONT_NAME}"'</family><prefer><family>icons-in-terminal</family></prefer><default><family>icons-in-terminal</family></default></alias>'
done

echo '  <alias><family>Monospace</family><default><family>icons-in-terminal</family></default></alias>'

echo '</fontconfig>'
