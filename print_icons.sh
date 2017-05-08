#!/usr/bin/bash

filename="$1"
YELLOW='\033[1;33m'
NC='\033[0m'

while read -r line
do
    if [ "${line:0:1}" = "#" ]
    then
	name_num=(${line//:/ })
	echo -e "\n${YELLOW}${name_num[0]:1} (${name_num[1]} glyphs)${NC}:"
    else
	str=""
	IFS=';' read -ra array_glyph <<< "$line"
	for glyph in "${array_glyph[@]}"; do
	    info=(${glyph//:/ })
	    if [ $# -gt 1 ]; then
		str="$str${info[0]}: \u${info[1]}\n"
	    else
		str="$str \u${info[1]}"
	    fi
	done
	echo -e $str | sed 's/ /  /g'
    fi

done < "$filename"

# while read -r line
# do
#     name=`echo $line | cut -d ':' -f 1`
#     start=`echo $line | cut -d ':' -f 2 | cut -d '-' -f 1`
#     end=`echo $line | cut -d ':' -f 2 | cut -d '-' -f 2`

#     echo -e "${YELLOW}$name${NC}:"

#     for x in $(seq $start $end)
#     do
# 	current=`printf "%x\n" "$x"`
# 	# current=`printf "%x\n" "$x"`
# 	echo -ne "\u$current  "
#     done

#     echo -e "\n"

# done < "$filename"
