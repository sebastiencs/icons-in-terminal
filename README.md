# icons-in-terminal

## Overview

`icons-in-terminal` allows you to get any fonts in your terminal without replacing or patching your font.  
You can add as many fonts as you want easily, you just need the ttf/odf file and add it to `config.json`.  

## Table of Contents

1. [**Installation**](#installation)  
2. [**Building**](#building)  
3. [**How it works**](#how-it-works)  
4. [**Included icons**](#included-icons)  
5. [**Screenshots**](#screenshots)  
6. [**Integrations**](#integrations)  
    * [**fish-shell**](#fish-integration)  
    * [**bash**](#bash-integration)  
    * [**emacs**](#emacs-integration)  
7. [**Todos**](#todos)  

## Installation

```bash
$ git clone https://github.com/sebastiencs/icons-in-terminal.git
```

To install `icons-in-terminal`, run:  
```bash
$ ./install.sh  
```
Or if your terminal is [supported](https://github.com/sebastiencs/icons-in-terminal/issues/1) (Experimental)
```bash
$ ./install-autodetect.sh 
```
Done ! You can start a new terminal and run `print_icons.sh` to see the installed gryphs.  
You can see names of each icon by giving any parameter to `print_icons.sh`:  
```bash
$ ./print_icons.sh
$ ./print_icons.sh --names
$ ./print_icons.sh --names | grep ANY_NAME
```
To use icons in your terminal, do not copy-paste icons from the output of `print_icons.sh` but use variable. See [integrations](#integrations).  
When one of the font provided will be update and add new icons, some codepoints in `icons-in-terminal.ttf` will be changed. The variable won't.  

## Building

If you want to add new font, there are a few dependencies to install:  

- Python 3
- [fontforge (with python extension)](https://fontforge.github.io)

You can add the name and path of your font to the file `config.json`.  
You should add it at the end of `config.json` to avoid to shift all codepoints of the others font.  
Each font can take parameters:  
- `start-from`: exclude all glyphs before the given codepoint.
- `until`: exclude all glyphs at the given codepoint and after.
- `excludes`: exclude the given codepoints.
- `move-vertically`: Use this parameter if your font and its glyphs are not centered vertically.
- `short-name`: Prefix to insert before the glyph name when you want to use the icon in your shell or anywhere else
- `map-names`: Define a name to the glyph. If not provided, the name will be read from the ttf file

Once done, you can run:  
```bash
$ ./build.sh
```
## How it works

This project is inspired by [awesome-terminal-fonts](https://github.com/gabrielelana/awesome-terminal-fonts) but is different.  
I don't modify any existing font, I create a new one and insert each glyphs from the provided fonts in the [private use areas](https://en.wikipedia.org/wiki/Private_Use_Areas).  
The file `~/.config/fontconfig/conf.d/30-icons.conf` tells to freetype to search the glyph in `icons-in-terminal.ttf` if it fails in your default font file. As the codepoints generated are in the private use areas, freetype should always fail and fallback to icons-in-terminal.ttf  
The only requirement is that your default font shouldn't be already patched/modified. But why use a patched font with limited glyphs when they are all included here :)  

## Included icons

There are already 3618 glyphs included:  

[powerline-extra-symbols (commit 4eae6e8)](https://github.com/ryanoasis/powerline-extra-symbols)  
[octicons v4.4.0](https://octicons.github.com/)  
[fontawesome v4.7](http://fontawesome.io/)  
[material-design-icons v3.0.1](https://github.com/google/material-design-icons)  
[file-icons v2.1.4](https://atom.io/packages/file-icons)  
[weather-icons v2.0.10](https://erikflowers.github.io/weather-icons/)  
[font-linux v0.9](https://github.com/Lukas-W/font-linux)  
[all-the-icons](https://github.com/domtronn/all-the-icons.el)  
[devicons v1.8.0](https://github.com/vorillaz/devicons)  
[Pomicons (commit bb0a579)](https://github.com/gabrielelana/pomicons)  
[linea v1.0](http://linea.io/)  
[font-mfizz v2.4.1](https://github.com/fizzed/font-mfizz)  

## Screenshots

![Screenshot the included icons](image/icons.jpg)
![Screenshot with fish](image/icons-fish.jpg)

## Integrations

### Fish integration

To use `icons-in-terminal` with fish, execute this line.  
```bash
$ ln -s ~/.local/share/icons-in-terminal/icons.fish ~/.config/fish/
```
Then add this line to `~/.config/fish/config.fish`:  
```bash
source ~/.config/fish/icons.fish
```
Restart a terminal, now you can print any icons with its name:  
```bash
$ echo $oct_location
```

### Bash integration

Run:  
```bash
$ ln -s ~/.local/share/icons-in-terminal/icons_bash.sh ~/.config/
```
Then add this line to your .bashrc:  
```bash
source ~/.config/icons_bash.sh
```
Restart a terminal, now you can print any icons with its name:  
```bash
$ echo -e $oct_location # note the '-e'
```

### Emacs integration

Make a link of the file `~/.local/share/icons-in-terminal/icons-in-terminal.el` in your load-path.  
```el
(require 'icons-in-terminal)
(insert (icons-in-terminal 'oct_flame))
```

## Todos

- Integrate with differents shells
