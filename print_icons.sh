#!/usr/bin/env bash

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'
filename="./build/mapping.txt"
count=0

while read -r line
do
    if [ "${line:0:1}" = "#" ]
    then
	name_num=(${line//:/ })
	echo -e "\n${YELLOW}${name_num[0]:1} (${name_num[1]} glyphs)${NC}:"
	count=$((count + name_num[1]))
    else
	str=""
	IFS=';' read -ra array_glyph <<< "$line"
	for glyph in "${array_glyph[@]}"; do
	    info=(${glyph//:/ })
	    if [ $# -gt 0 ]; then
		str="$str${info[0]}: \u${info[1]}\n"
	    else
		str="$str \u${info[1]}"
	    fi
	done
	echo -e $str | sed 's/ /  /g'
    fi
done < "$filename"

echo -e "\n${GREEN}Total: $count glyphes${NC}"
