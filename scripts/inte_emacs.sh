#!/usr/bin/bash

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'
filename="./build/mapping.txt"
count=0

name=""

echo "(require 'font-lock+)

(defconst icons-in-terminal-alist
  '("

while read -r line
do
    if [ "${line:0:1}" = "#" ]
    then
	name_num=(${line//:/ })
	name=${name_num[0]:1}
    else
	str=""
	IFS=';' read -ra array_glyph <<< "$line"
	for glyph in "${array_glyph[@]}"; do
	    info=(${glyph//:/ })
	    echo "    ( ${info[0]} . \"\x${info[1]}\" )"
	done
    fi

done < "$filename"

echo "    ))

(defun icons-in-terminal (name)
  \"Return icon from NAME.
Example of use: (insert (icons-in-terminal 'oct_flame))\"
  (propertize (alist-get name icons-in-terminal-alist) 'face '(:family \"icons-in-terminal\") 'font-lock-ignore t))

(provide 'icons-in-terminal)"
