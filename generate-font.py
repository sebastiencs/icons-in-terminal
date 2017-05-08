#!/usr/bin/env python3

import string
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

# Insert the powerline glyphs at the same place that all the patched powerline fonts to make
# our font compatible with most of plugins/modules that insert those glyphs
def insert_powerline_extra(dest):
    codepoint = POWERLINE_START
    font = fontforge.open("./fonts/PowerlineExtraSymbols.otf")
    font.em = FONT_EM
    excludes = [ 0xE0A4, 0xE0A5, 0xE0A6, 0xE0A7, 0xE0A8, 0xE0A9, 0xE0AA, 0xE0AB,
                 0xE0AC, 0xE0AD, 0xE0AE, 0xE0AF, 0xE0C9, 0xE0CB, 0xE0D3 ]
    inserted = []

    while codepoint < POWERLINE_END:
        if codepoint in excludes:
            codepoint += 1
            continue
        font.selection.select(codepoint)
        font.copy()
        dest.selection.select(codepoint)
        dest.paste()
        inserted.append(codepoint)
        codepoint += 1
    print("#powerline-extras:" + str(len(inserted)))
    for x in inserted:
        print("powerline:" + str(hex(x)).replace("0x", ""), end=';')
    print("")

# Return true if the format of the name is something like 'uniXXXX' where X are
# hexadecimals
def is_default_name(name):
    if len(name) != 7:
        return False
    if not name.startswith("uni"):
        return False
    if not all(c in string.hexdigits for c in name[-4:]):
        return False
    return True

# If the name is a default one, return a new default name corresponding to its codepoint
def make_name(name, codepoint):
    if is_default_name(name):
        return "uni" + str(hex(codepoint)).replace("0x", "").upper()
    return name

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

    for json_file in config_data:

        font = fontforge.open(json_file["path"])
        font.em = FONT_EM

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
        inserted = []

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
                dest.selection.select(codepoint)
                dest.paste()
                dest.transform(psMat.translate(0, move_vertically))
                new_name = make_name(name, codepoint)
                dest.createMappedChar(codepoint).glyphname = new_name
                inserted.append((new_name ,codepoint))
                codepoint += 1

        print("#" + json_file["name"] + ":" + str(len(inserted)))
        for (name, x) in inserted:
            print(name + ":" + str(hex(x)).replace("0x", ""), end=';')
        print("")

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
