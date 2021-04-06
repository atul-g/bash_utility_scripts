#!/usr/bin/sh

# Function to use 0x0.st pastebin service easily
# Credits to 0x0.st for providing such a platform while also respecting
# privacy.

# One can paste the following function alone in a .zshrc/.bashrc file and
# start using it

0x0() {
	which xclip > /dev/null
	if [ $? -ne 0 ]
	then
		echo "This function needs xclip. Install it please."
		return 1
	fi

	if [ "$1" = "c" ]
	then
		xclip -o > /tmp/0x0-pastebin.temp
		echo -e "making paste from clipboard...\n"
		if [ "$2" = "s" ]
		then
			echo "######## Contents of paste #########"
			cat /tmp/0x0-pastebin.temp
			echo -e "\n########### End of paste ###########\n"
		fi
		curl -F 'file=@/tmp/0x0-pastebin.temp' https://0x0.st

	elif [ "$1" = "f" ]
	then
		echo -e "making paste from file...\n"
		# if show argument was also passed
		if [ "$2" = "s" ]
		then
			echo "######## Contents of paste #########"
			cat "$3"
			echo -e "\n########### End of paste ###########\n"
			curl -F "file=@"${3}"" https://0x0.st

		elif [ "$2" != "" ]
		then
			curl -F "file=@"${2}"" https://0x0.st
		else
			echo "No file passed...Aborting."
			return 2 # not really necessay, but it helps
				 # for setting $? as non zero
		fi
	else
		echo "No arguments passed..."
		echo "Usage: 0x0 {c|f} [s] [/path/to/file]"
		echo "c - make paste from system clipboard"
		echo "f - make paste from specified file"
		echo "s - show the contents of paste created"
		return 2
	fi
}


0x0 "$*"
