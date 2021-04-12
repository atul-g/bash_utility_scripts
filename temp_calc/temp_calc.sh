#!/usr/bin/bash

######### DEAFULT ARGUMENT VALUES
TIME=30
CORES=4

######### TEXT STYLING VARIABLES
RED_COLOR="\033[0;31m" #to get red colored text after this variable
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
######### TO GET THE ARGUMENTS
while getopts 'hc:t:' flag; do
        case "$flag" in
		h)
			echo  "${BOLD}\n\tA utility script to measure CPU temperature while running a stress test\n"
			echo   "\tUSAGE:${BOLD} ./temp_calc.sh [-c <value> ] [-t <value>]"
			echo  "\n\t -c : ${BOLD}CORES${NORMAL} - Assign the number of CPU cores on which you want to run 100 percent load. Default value is 4.\n"
			echo  "\n\t -t : ${BOLD}TIME${NORMAL} - Specify the time for which you want the stress test to run in seconds. Default time is 30s.\n"
			echo  "${BOLD}\tNOTE: THIS SCRIPT DEPENDS ON stress PACKAGE${NORMAL}.\n\tInstall it using \"sudo apt install stress\"\n"
			exit 0;;

                c) CORES=$OPTARG ;;
                t) TIME=$OPTARG ;;
                \?) echo "script usage: $(basename $0) [-c <number of cores>] [-t <time duration in seconds>]"
                        exit 1;;
        esac
done

######### FUNCTION THAT WILL MEASURE THE AVG TEMPERATURE
temp_measure() {
	i=0 #time iterator
	j=0 #count iterator
	max_temp=0 #init
	while [ $(echo "$i< $TIME" | bc) -ne 0 ];
	do
		sleep 0.5;
		j=$((j+=1));
		i=$(echo $i+0.5 | bc);
		temp=$(sed -n 3p /sys/class/thermal/thermal_zone*/temp);
		
		if [ $max_temp -lt $temp ]
		then
			max_temp=$temp
		fi
		
		tot_temp=$((tot_temp+=temp))
		wait;
	done

	avg_temp=$(echo "($tot_temp/$j)/1000" | bc)

	echo  "\n\tThe average temperature in the last $i seconds is:${RED_COLOR} $avg_temp celsius${NORMAL}"
	echo  "\tThe maximum temperature during the test was: ${RED_COLOR}$((max_temp/1000)) celsius\n"
	tput sgr0
	exit 0
}


echo  "\n\n${BOLD}\tRUNNING STRESS TEST AND MEASURING THE AVERAGE TEMPERATURE${NORMAL}\n\n"
echo  "\tDURATION: ${TIME}s\n\tCPU CORES: $CORES\n\n"

stress --cpu $CORES --timeout $TIME & temp_measure
