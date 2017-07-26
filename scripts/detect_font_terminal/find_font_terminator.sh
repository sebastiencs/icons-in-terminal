#!/usr/bin/env bash

BASEDIR=$(dirname `readlink -f "$0"`)
source ${BASEDIR}/../colors.sh

if [ -n "$VERBOSE" ]; then
    echo -e "${CYAN}- TERMINATOR:${NORMAL}"
fi

GLOBAL_PROFILES=()

# Print only the [[profiles]] section in the config file
get_profiles() {
    PROFILE=0
    while IFS='' read -r LINE || [[ -n "$LINE" ]]; do
	LINE=`echo $LINE | sed 's/^ *//;s/ *$//'`
	case $LINE in
	    "[global_config]"|"[keybindings]"|"[layouts]"|"[plugins]") PROFILE=0;;
	    "[profiles]") PROFILE=1;;
	esac
	if [ $PROFILE -eq 1 -a "$LINE" != "[profiles]" ]; then
	    echo "${LINE[0]}" | sed 's/ = /=/g'
	    GLOBAL_PROFILES+=("${LINE[0]}")
	fi
    done  < "$1"
}

# Print names of profiles
get_names_of_profiles() {
    while IFS='' read -r LINE || [[ -n "$LINE" ]]; do
	case $LINE in
	    \[\[*\]\]) echo "$LINE";;
	esac
    done
}

FOUND=0

# For each section name, get the value of font and use_system_font
read_profiles() {
    get_profiles $1 > /dev/null # Use to initialize GLOBAL_PROFILES
    NAMES=(`get_profiles $1 | get_names_of_profiles`) # because this line is executed in a subshell and doesn't modify GLOBAL_PROFILES
    for NAME in "${NAMES[@]}"; do
	ON_PROFILE=0
	USE_SYSTEM_FONT=1
	FONT_NAME=""
	for LINE_PROFILE in "${GLOBAL_PROFILES[@]}"; do
	    case "$LINE_PROFILE" in
		"$NAME") ON_PROFILE=1;;
		\[\[*\]\]) ON_PROFILE=0;;
	    esac
	    LINE_PROFILE=`echo $LINE_PROFILE | sed 's/ = /=/g'`
	    if [[ $ON_PROFILE -eq 1 ]]; then
		case "$LINE_PROFILE" in
		    font=*) FONT_NAME=`echo $LINE_PROFILE | sed 's/font=//g' | rev | cut -d ' ' -f 2- | rev`;;
		    use_system_font=False) USE_SYSTEM_FONT=0 ;;
		esac
#		echo $LINE_PROFILE
	    fi
	done

	if [ $USE_SYSTEM_FONT -eq 1 -o "$FONT_NAME" = "" ]; then
	    FONT_NAME=`${BASEDIR}/find_font_system.sh`
	fi

	if [ -n "$VERBOSE" ]; then
	    if [ $USE_SYSTEM_FONT -eq 1 ]; then
		USE_SYSTEM_FONT="true"
	    else
		USE_SYSTEM_FONT="false"
	    fi
	    echo -e "    ${UNDERLINE}Profile '${NAME:2:-2}':${NORMAL}"
	    echo -e "\tFont familly:\t\t${GREEN}$FONT_NAME${NORMAL}"
	    echo -e "\tUse system font:\t$USE_SYSTEM_FONT"
	else
	    echo "$FONT_NAME"
	fi

	FOUND=1

    done
}

FILE_CONFIG=${XDG_CONFIG_HOME:-${HOME}/.config}/terminator/config

if [ -e $FILE_CONFIG -a -r $FILE_CONFIG  ];then
    read_profiles "$FILE_CONFIG"
fi

if [ $FOUND -eq 0 ];then

    which terminator 2> /dev/null > /dev/null
    EXIST=$?

    if [ $EXIST -eq 0 -a -n "$VERBOSE" ];then
	echo -e "Installed but no config file found:\nUse system font instead: \t${GREEN}`${BASEDIR}/find_font_system.sh` $NORMAL"
    elif [ $EXIST -eq 0 ]; then
	./${BASEDIR}find_font_system.sh
    elif [ -n "$VERBOSE" ]; then
	echo "No font found"
    fi
fi
