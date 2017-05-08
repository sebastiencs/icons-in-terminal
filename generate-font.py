#!/usr/bin/env python3

import os
import sys
import json
import fontforge
import psMat

PUA_START = 0xE000
PUA_END = 0xF8FF
FONT_EM = 1024
POWERLINE_START = 0xE0A0
POWERLINE_END = 0xE0D5


def insert_powerline_extra(dest):
    codepoint = POWERLINE_START
    font = fontforge.open("./fonts/PowerlineExtraSymbols.otf")
    font.em = FONT_EM
    inserted = []

    while codepoint < POWERLINE_END:
        if codepoint >= 0xE0A4 and codepoint <= 0xE0AF:
            codepoint += 1
            continue
        font.selection.select(codepoint)
        font.copy()
        dest.selection.select(codepoint)
        dest.paste()
        inserted.append(codepoint)
        codepoint += 1
    print ("powerline-extras:" + hex(POWERLINE_START) + "-" + hex(POWERLINE_END))

if len(sys.argv) < 2:
    print("Give me a config file")
    sys.exit(1)

with open(sys.argv[1]) as config_file:
    config_data = json.load(config_file)

    dest = fontforge.font()
    dest.em = FONT_EM
#    dest.encoding = "UnicodeFull"
    dest.encoding = "ISO10646"

    insert_powerline_extra(dest)

    codepoint = PUA_START

    num_file = 0

    for json_file in config_data:

        font = fontforge.open(json_file["path"])

        font.em = FONT_EM

        num_file += 1

        excludes = []
        if "excludes" in json_file:
            excludes = list(map(lambda x : int(x, 16), json_file["excludes"]))

        start_from = 0
        if "start-from" in json_file:
            start_from = int(json_file["start-from"], 16)

        until = -1
        if "until" in json_file:
            until = int(json_file["until"], 16)

        move_vertically = 0
        if "move-vertically" in json_file:
            move_vertically = int(json_file["move-vertically"])

        start = codepoint

        for symbol in font.glyphs("encoding"):
            if codepoint == POWERLINE_START:
                codepoint = POWERLINE_END
            if (symbol.encoding in excludes or
                symbol.encoding < start_from or
                (until > 0 and symbol.encoding >= until)):
                continue
            if symbol.width > 0 and symbol.unicode > 0:
                encoding = symbol.encoding
                name = symbol.glyphname
                font.selection.select(encoding)
                font.copy()
#                print (json_file["name"] + ": " + name + " : " + hex(codepoint))
                dest.selection.select(codepoint)
                dest.paste()
                dest.transform(psMat.translate(0, move_vertically))
                dest.createMappedChar(codepoint).glyphname = name
                codepoint += 1

        print(json_file["name"] + ":" + hex(start) + "-" + hex(codepoint - 1))


    dest.em = FONT_EM
    dest.fontname = "icons-in-terminal"
    dest.familyname = "icons-in-terminal"
    dest.fullname = "icons-in-terminal"
    dest.appendSFNTName('English (US)', 'Preferred Family', dest.familyname)
    dest.appendSFNTName('English (US)', 'Compatible Full', dest.fullname)
    dest.fontname= "icons-in-terminal"
    dest.generate("icons-in-terminal.ttf")
    sys.exit(0)

sys.exit(1)
