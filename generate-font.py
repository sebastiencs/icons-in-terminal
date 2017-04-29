#!/usr/bin/env python3

import os
import sys
import json
import fontforge

PRIVATE_USE_AREA_START = 0xE000
PRIVATE_USE_AREA_END = 0xF8FF
FONT_EM = 1024

if len(sys.argv) < 2:
    print("Give me a config file")
    sys.exit(1)

with open(sys.argv[1]) as config_file:
    config_data = json.load(config_file)

    dest = fontforge.font()
    dest.em = FONT_EM
    dest.encoding = "ISO10646"

    codepoint = PRIVATE_USE_AREA_START

    num_file = 0

    for json_file in config_data:

        font = fontforge.open(json_file["path"])

        font.em = FONT_EM

        num_file += 1

        for symbol in font.glyphs("encoding"):
            if symbol.width > 0 and symbol.unicode > 0:
                encoding = symbol.encoding
                name = symbol.glyphname
                font.selection.select(encoding)
                font.copy()
                print (json_file["name"] + ": " + name + " : " + hex(codepoint))
                dest.selection.select(codepoint)
                dest.paste()
                dest.createMappedChar(codepoint).glyphname = name
                codepoint += 1

    dest.em = FONT_EM
    dest.fontname = "myicons"
    dest.familyname = "myicons"
    dest.fullname = "myicons"
    dest.appendSFNTName('English (US)', 'Preferred Family', dest.familyname)
    dest.appendSFNTName('English (US)', 'Compatible Full', dest.fullname)
    dest.fontname= "myicons"
    dest.generate("myicons.ttf")
    sys.exit(0)

sys.exit(1)
