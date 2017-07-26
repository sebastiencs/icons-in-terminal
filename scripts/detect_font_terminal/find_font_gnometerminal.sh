#!/usr/bin/env bash

BASEDIR=$(dirname `readlink -f "$0"`)
source ${BASEDIR}/../colors.sh

if [ -n "$VERBOSE" ]; then
    echo -e "${CYAN}- GNOME TERMINAL:${NORMAL}"
fi

LIST_PROFILES=`dconf read /org/gnome/terminal/legacy/profiles:/list`
LIST_PROFILES="${LIST_PROFILES:1:${#LIST_PROFILES}-2}"
LIST_PROFILES=`echo $LIST_PROFILES | sed "s/, /\n/g" | sed -e "s/^'//" -e "s/'\$//"`

IFS=' ' read -r -a LIST_PROFILES <<< $LIST_PROFILES
for profile in "${LIST_PROFILES[@]}"; do

    NAME=`dconf read /org/gnome/terminal/legacy/profiles:/:$profile/visible-name`
    if [ -z "$FONT" ]; then
	NAME="'Default'"
    fi

    USE_SYSTEM_FONT=`dconf read /org/gnome/terminal/legacy/profiles:/:$profile/use-system-font`
    FONT=`dconf read /org/gnome/terminal/legacy/profiles:/:$profile/font | sed -e "s/^'//" -e "s/'\$//" | rev | cut -d ' ' -f 2- | rev`

    if [ "$USE_SYSTEM_FONT" = "true" ]; then
	FONT=`./find_font_system.sh`
	if [ -z "$FONT" ]; then
	    echo -e "${RED}ERROR: ${NORMAL}${0}:"
	    echo "Fail to retrieve font system"
	    echo "Please comment this issue: https://github.com/sebastiencs/icons-in-terminal/issues/1"
	    echo "Use install.sh instead"
	    exit 1
	fi
    fi

    if [ -n "$VERBOSE" ]; then
       echo -e "    ${UNDERLINE}Profile: $NAME${NORMAL}"
#       echo -e "   ${UNDERLINE}Profile: $NAME ($profile)${NORMAL}"
       echo -e "\tFont family:\t\t${GREEN}$FONT${NORMAL}"
       echo -e "\tUse system font:\t$USE_SYSTEM_FONT"
    else
	echo "$FONT"
    fi
done

if [ ${#LIST_PROFILES[@]} -eq 0 ]; then
   echo "No font found"
fi
