# Script to use 0x0's file url services 

This script helps one to use the 0x0.st's pastebin-like services in an easy way directly from the terminal. One can also copy the 0x0() function body given in this script and copy it to shell's rc file (.zshrc/.bashrc) and start using `0x0`.

### Usage
One needs to copy the `0x0.sh` script provided in this repo into `/usr/share/bin` or any other directory which is included in `PATH`. You can also just copy the `0x0()` function definition into the shell's rc file as mentioned before.

Here is the sample run of the file:
Running `0x0` without any arguments gives the usage as output:

```
~
base ❯ 0x0
No arguments passed...
Usage: 0x0 {c|f} [s] [/path/to/file]
c - make paste from system clipboard
f - make paste from specified file
s - show the contents of paste created
```

Running `0x0 c s` creates a 0x0 link of whatever text that you have currently in your clipboard. There is one thing to keep in mind, if you are copying text from your terminal/console, simply highlighting the text with cursor itself allows `xclip` to capture it (pressing `Ctrl+c+v` in terminals may not be captured by `xclip`, while simply highlighting them does). 

```
~
base ❯ 0x0 c s
making paste from clipboard...

######## Contents of paste #########
This text is from my system clipboard
########### End of paste ###########

https://0x0.st/-Tii.temp
```

The s above is used to "show" whatever text's link is being made.

You can also create a paste link from a file:

```
~
base ❯ 0x0 f s /tmp/trial.txt
making paste from file...

######## Contents of paste #########
This content is from the file: /tmp/trial.txt

########### End of paste ###########

https://0x0.st/-Ti-.txt
```
