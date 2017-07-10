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


(defun icons-in-terminal (name &rest attributes)
  \"Return icon from NAME with optional ATTRIBUTES.
Attributes are face attributes or the display specification raise with :raise
the keyword :face can be use as an alias for :inherit

Examples of use: (insert (icons-in-terminal 'oct_flame))
                 (insert (icons-in-terminal 'oct_flame :foreground \\\"red\\\" :height 1.4))
                 (insert (icons-in-terminal 'oct_flame :face any-face :underline t))
                 (insert (icons-in-terminal 'oct_flame :inherit any-face :underline t)) ;; Similar to the line above
                 (insert (icons-in-terminal 'oct_flame :raise 0.2)).\"
  (let* ((list-attributes (list :family \"icons-in-terminal\"))
	 (face (or (plist-get attributes :inherit) (plist-get attributes :face)))
	 (foreground (plist-get attributes :foreground))
	 (distant-foreground (plist-get attributes :distant-foreground))
	 (background (plist-get attributes :background))
	 (width (plist-get attributes :width))
	 (height (plist-get attributes :height))
	 (underline (plist-get attributes :underline))
	 (overline (plist-get attributes :overline))
	 (box (plist-get attributes :box))
	 (raise (or (plist-get attributes :raise) -0.05)))
    (when face (push \`(:inherit ,face) list-attributes))
    (when foreground (push \`(:foreground ,foreground) list-attributes))
    (when distant-foreground (push \`(:distant-foreground ,distant-foreground) list-attributes))
    (when background (push \`(:background ,background) list-attributes))
    (when width (push \`(:width ,width) list-attributes))
    (when height (push \`(:height ,height) list-attributes))
    (when underline (push \`(:underline ,underline) list-attributes))
    (when overline (push \`(:overline ,overline) list-attributes))
    (when box (push \`(:box ,box) list-attributes))
    (propertize (alist-get name icons-in-terminal-alist)
		'face list-attributes
		'display \`(raise ,raise)
		'font-lock-ignore t)))



;;(defun icons-in-terminal (name &rest attributes)
;;  \"Return icon from NAME with optional ATTRIBUTES.
;;Attributes are face attributes or the display specification raise with :raise
;;the keyword :face can be use as an alias for :inherit
;;
;;Examples of use: (insert (icons-in-terminal 'oct_flame))
;;                 (insert (icons-in-terminal 'oct_flame :foreground \\\"red\\\" :height 1.4))
;;                 (insert (icons-in-terminal 'oct_flame :face any-face :underline t))
;;                 (insert (icons-in-terminal 'oct_flame :inherit any-face :underline t)) ;; Similar to the line above
;;                 (insert (icons-in-terminal 'oct_flame :raise 0.2)).\"
;;  (let* ((list-attributes '(:family \"icons-in-terminal\"))
;;	 (face (or (plist-get attributes :inherit) (plist-get attributes :face)))
;;	 (foreground (plist-get attributes :foreground))
;;	 (distant-foreground (plist-get attributes :distant-foreground))
;;	 (background (plist-get attributes :background))
;;	 (width (plist-get attributes :width))
;;	 (height (plist-get attributes :height))
;;	 (underline (plist-get attributes :underline))
;;	 (overline (plist-get attributes :overline))
;;	 (box (plist-get attributes :box))
;;	 (raise (or (plist-get attributes :raise) -0.05)))
;;    (when face (push \`(:inherit ,face) list-attributes))
;;    (when foreground (push \`(:foreground ,foreground) list-attributes))
;;    (when distant-foreground (push \`(:distant-foreground ,distant-foreground) list-attributes))
;;    (when background (push \`(:background ,background) list-attributes))
;;    (when width (push \`(:width ,width) list-attributes))
;;    (when height (push \`(:height ,height) list-attributes))
;;    (when underline (push \`(:underline ,underline) list-attributes))
;;    (when overline (push \`(:overline ,overline) list-attributes))
;;    (when box (push \`(:box ,box) list-attributes))
;;    (propertize (alist-get name icons-in-terminal-alist)
;;		'face list-attributes
;;		'display \`(raise ,raise)
;;		'font-lock-ignore t)))
;;

;;(defun icons-in-terminal (name &rest attributes)
;;  \"Return icon from NAME with optional ATTRIBUTES.
;;Attributes are face attributes or the display specification raise with :raise
;;the keyword :face can be use as an alias for :inherit
;;
;;Examples of use: (insert (icons-in-terminal 'oct_flame))
;;                 (insert (icons-in-terminal 'oct_flame :foreground \\\"red\\\" :height 1.4))
;;                 (insert (icons-in-terminal 'oct_flame :face any-face :underline t))
;;                 (insert (icons-in-terminal 'oct_flame :inherit any-face :underline t)) ;; Similar to the line above
;;                 (insert (icons-in-terminal 'oct_flame :raise 0.2)).\"
;;  (let* ((face (plist-get attributes :face))
;;	 (raise (or (plist-get attributes :raise) -0.05)))
;;    (propertize (alist-get name icons-in-terminal-alist)
;;		'face (append \`(:family \"icons-in-terminal\" :inherit ,face) attributes)
;;		'display \`(raise ,raise)
;;		'font-lock-ignore t)
;;    ))
;;

;;(defun icons-in-terminal (name &rest options)
;;  \"Return icon from NAME with optional OPTIONS.
;;Examples of use: (insert (icons-in-terminal 'oct_flame)).
;;                 (insert (icons-in-terminal 'oct_flame '(:foreground \\\"red\\\")))
;;                 (insert (icons-in-terminal 'oct_flame face)).\"
;;  (if (listp options)
;;      (propertize (alist-get name icons-in-terminal-alist)
;;		  'face (cons '(:family \"icons-in-terminal\") options)
;;		  'font-lock-ignore t)
;;    (let ((face (plist-get options :face))
;;	  (raise (plist-get options :raise))
;;	  (height (plist-get options :height))
;;	  (distant-foreground (plist-get options :distant-foreground))
;;	  (background (plist-get options :background))
;;	  (underline (plist-get options :underline))
;;	  (overline (plist-get options :overline))
;;	  (strike-through (plist-get options :strike-through))
;;	  (box (plist-get options :box))
;;	  (inverse-video (plist-get options :inverse-video))
;;	  (stipple (plist-get options :stipple))
;;	  (foreground (plist-get options :foreground)))
;;      (propertize (alist-get name icons-in-terminal-alist)
;;		  'face \`(:family \"icons-in-terminal\" :inherit ,face :height ,height :foreground ,foreground
;;				  :distant-foreground ,distant-foreground :background ,background :underline ,underline
;;				  :overline ,overline :strike-through ,strike-through :box ,box :inverse-video ,inverse-video
;;				  :stipple ,stipple)
;;		  'display \`(raise ,raise)
;;		  'font-lock-ignore t))))

(provide 'icons-in-terminal)"
