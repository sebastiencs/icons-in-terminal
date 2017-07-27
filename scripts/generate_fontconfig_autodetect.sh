#!/usr/bin/env bash

# Generate a fontconfig configuration file
# See /etc/fonts/conf.d/README

BASEDIR=$(dirname `readlink -f "$0"`)
source ${BASEDIR}/colors.sh

SCRIPTS[0]=${BASEDIR}/detect_font_terminal/find_font_gnometerminal.sh
SCRIPTS[1]=${BASEDIR}/detect_font_terminal/find_font_terminator.sh

declare -A FONT_NAMES

if [ -z $VERBOSE ]; then
    echo '<?xml version="1.0"?>'
    echo '<!DOCTYPE fontconfig SYSTEM "fonts.dtd">'
    echo '<fontconfig>'
else
    echo -e "\nDetected terminals fonts:\n"
fi

for SCRIPT in "${SCRIPTS[@]}"; do
    if [ -n "$VERBOSE" ]; then
	eval "$SCRIPT"
    else
	while IFS='\n' read FONT_NAME; do
	    FONT_NAME=`echo $FONT_NAME | tr -d '\n'`
	    FONT_NAMES["$FONT_NAME"]=1
	done < <(eval $SCRIPT)
    fi
done

for FONT_NAME in "${!FONT_NAMES[@]}"; do
    if [ -z $VERBOSE ]; then
	echo '  <alias><family>'"${FONT_NAME}"'</family><prefer><family>icons-in-terminal</family></prefer></alias>'
	#echo '  <alias><family>'"${FONT_NAME}"'</family><prefer><family>icons-in-terminal</family></prefer><default><family>icons-in-terminal</family></default></alias>'
    fi
done

if [ -z $VERBOSE ]; then
    echo '</fontconfig>'
else
    echo -e "\n${YELLOW}IMPORTANT:${NORMAL}"
    echo "install-autodetect.sh is experimental"
    echo -e "If your terminal isn't listed or if there is not your font, ${UNDERLINE}use install.sh instead${NORMAL}"
    echo "See https://github.com/sebastiencs/icons-in-terminal/issues/1"
fi
