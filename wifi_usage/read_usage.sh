#!/usr/bin/sh

filepath="$HOME/usage"
RED_COLOR="\033[0;31m" #to get red colored text after this variable
NORMAL=$(tput sgr0)

if [ -f "$filepath" ]
then
	cycle_date=$(head -n 1 "$filepath")
else
	printf "\n\tYou need to run the ./wifi_filepath script before you can run this script to see wifi filepath stats.\n"
	exit 0
fi

#default date

cycle_date=$(head -n 1 $filepath)
cyc_date=$cycle_date

######### TO GET THE ARGUMENTS
while getopts 'hd:' flag; do
        case "$flag" in
		h)
			printf "\n\tWIFI USAGE COUNTER: A utility script to measure WIFI filepath across different WIFI routers\n"
			printf  "\tUSAGE: ./wifi_filepath.sh [-d <value> ]"
			printf "\nOPTIONS:"
			printf "\n\t-d : CYCLE DATE - Set the cycle date. Value should be a day of the month.\n"
			printf "\t-h: Help"
			exit 0;;

                d) cyc_date=$OPTARG ;;
                \?) echo "script filepath: ./wifi_filepath [-c <number of cores>] [-t <time duration in seconds>]"
                        exit 1;;
        esac
done


if [ "$cyc_date" -ge 1 ] && [ "$cyc_date" -le 30 ]
then
	cycle_date="$cyc_date"
else
	echo Invalid Date entered. Cycle Date remains unchanged.
fi

sed -i "1s/.*/$cycle_date/" "$filepath"

while read -r line
do
	if [ "$line" =~ ^[[:digit:]]+$ ]; then # to skip the first line
		continue
	fi
	ssid=$(echo "$line" | cut -d " " -f 2)
	used=$(echo "$line" | cut -d " " -f 3)
	used_mb=$(echo "scale=4; ($used/1024)/1024" | bc -l )
	printf "\t\nWIFI data used by ${RED_COLOR}$ssid${NORMAL} for the monthly cycle is: $used_mb MiB\n"
done < "$filepath";

exit 0
