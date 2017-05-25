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

def read_map_names(filename):
    array = []
    with open(filename) as file_map:
        lines = file_map.readlines()
        lines = [x.strip() for x in lines]
        for line in lines:
            if len(line) == 0:
                continue
            tab = line.split()
            if tab[0][0] == '@':
                array.append((tab[0][1:], ord(tab[1][0])))
            else:
                array.append((tab[0], int(tab[1], 16)))
    return array

def lookup_map_name(map_names, codepoint, fallback_name):
    for name, code in map_names:
        if code == codepoint:
            return name
    return fallback_name

# Insert the powerline glyphs at the same place that all the patched powerline fonts to make
# our font compatible with most of plugins/modules that insert those glyphs
def insert_powerline_extra(dest):
    codepoint = POWERLINE_START
    font = fontforge.open("./fonts/PowerlineExtraSymbols.otf")
    font.em = FONT_EM
    map_names = read_map_names("./fonts/PowerlineExtraSymbols-map")
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
        number = hex(x).replace("0x", "")
        name = lookup_map_name(map_names, x, number)
        print("powerline_" + name + ":" + number, end=';')
    print("")

# Return true if the format of the name is something like 'uniXXXX' where X are
# hexadecimals
def is_default_name(name):
    if (len(name) != 7 or
        not name.startswith("uni") or
        not all(c in string.hexdigits for c in name[-4:])):
        return False
    return True

# Name the glyph according to the font name
def make_name(name, name_font):
    name = name.lower()
    if is_default_name(name):
        return name_font + "_" + name[-4:]
    return name_font + "_" + name.replace("-", "_")

if len(sys.argv) < 2:
    print("Give me a config file", file=sys.stderr)
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

        name_font = json_file["name"]
        if "short-name" in json_file:
            name_font = json_file["short-name"]
        name_font = name_font.replace("-", "_")

        map_names = []
        if "map-names" in json_file:
            map_names = read_map_names(json_file["map-names"])

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
                if encoding == 0x20:
                    dest.selection.select(0x20)
                    dest.paste()
                    continue
                dest.selection.select(codepoint)
                dest.paste()
                dest.transform(psMat.translate(0, move_vertically))
                if len(map_names) > 0:
                    name = lookup_map_name(map_names, encoding, name)
                new_name = make_name(name, name_font)
                dest.createMappedChar(codepoint).glyphname = new_name
                inserted.append((new_name ,codepoint))
                codepoint += 1

        print("#" + json_file["name"] + ":" + str(len(inserted)))
        for (name, x) in inserted:
            print(name + ":" + str(hex(x)).replace("0x", ""), end=';')
        print("")

    ascent = dest.ascent
    descent = dest.descent

    dest.os2_winascent_add = 0
    dest.os2_windescent_add = 0
    dest.os2_typoascent_add = 0
    dest.os2_typodescent_add = 0
    dest.hhea_ascent_add = 0
    dest.hhea_descent_add = 0

    # print ("ASCENT: " + str(ascent))
    # print ("DESCENT: " + str(descent))

    dest.os2_winascent = ascent
    dest.os2_windescent = descent
    dest.os2_typoascent = ascent
    dest.os2_typodescent = -descent
    dest.hhea_ascent = ascent
    dest.hhea_descent = -descent

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
