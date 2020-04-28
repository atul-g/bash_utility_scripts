#!/usr/bin/env bash

RED_COLOR="\033[0;31m" #to get red colored text after this variable
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

if [[ -f "./usage" ]]
then
	cycle_date=$(head -n 1 usage)
else
	echo -e "\n\tYou need to run the ./wifi_usage script before you can run this script to see wifi usage stats.\n"
fi

#default date
cycle_date=$(head -n 1 usage)
cyc_date=$cycle_date
######### TO GET THE ARGUMENTS
while getopts 'hd:' flag; do
        case "$flag" in
		h)
			echo -e "\n\tWIFI USAGE COUNTER: A utility script to measure WIFI usage across different WIFI routers\n"
			echo -e  "\tUSAGE: ./wifi_usage.sh [-d <value> ]"
			echo -e "\nOPTIONS:"
			echo -e "\n\t-d : CYCLE DATE - Set the cycle date. Value should be a day of the month.\n"
			echo -e "\t-h: Help"
			exit 0;;

                d) cyc_date=$OPTARG ;;
                \?) echo "script usage: ./wifi_usage [-c <number of cores>] [-t <time duration in seconds>]"
                        exit 1;;
        esac
done


if [ $cyc_date -ge 1 ] && [ $cyc_date -le 30 ]
then
	cycle_date=$cyc_date
else
	echo Invalid Date entered. Cycle Date remains unchanged.
fi

sed -i "1s/.*/$cycle_date/" usage

while read -r line
do
	if [[ $line =~ ^[[:digit:]]+$ ]]; then # to skip the first line
		continue
	fi
	ssid=$(echo $line | cut -d " " -f 2)
	used=$(echo $line | cut -d " " -f 3)
	used_mb=$(echo "scale=4; ($used/1024)/1024" | bc -l )
	echo -e "\t\nWIFI data used by ${RED_COLOR}$ssid${NORMAL} for the monthly cycle is: $used_mb MiB\n"
done < usage;

exit 0
