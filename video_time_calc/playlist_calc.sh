#!/usr/bin/sh

wd="$1"
if [ ! -d "$wd" ]; then
	echo "Please enter an existing directory path. Try to enter the path in double quotes."
	echo 'Example: ./playlist_calc.sh "/home/user/videos"'
	exit 1
fi

init_date='jan 1 1970' #this is used as reference date to which every vid length is added to get the relative time in seconds of each vid

sum=0

while read i
do
	
	vid_length=$(ffmpeg -i "$i"  2>&1 | grep 'Duration' | awk '{print $2}' | tr -d ,)
	#echo "$(date -u -d "$init_date $vid_length" +%s)"
	sum="$(date -u -d "$init_date $vid_length" +%s) + $sum"	
done <<< "$(find "$wd" -iname "*.mp4")"

#in the above loop we passed the find command as a form of 'here string' because if we
#were to pass the output of find command to while loop using pipes, it will only open the while
#loop in a subshell, and any modifications to sum variable will not be reflected outside the while loop.

tot_time=$(echo "$sum" | bc)

printf '\nThe total time of all the videos in the given directory: %dh:%dm:%ds\n' $(("$tot_time"/3600))  $(("$tot_time"%3600/60)) $(("$tot_time"%60))



