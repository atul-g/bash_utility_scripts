#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
filepath="$HOME/usage" #since cron jobs have a current working directory usually set as home

date_check() {
	if [ -f "$filepath" ]
	then 
		cur_date=$(date +%s)
		last_mod_date=$(date -r "$filepath" +%s)
		if [ "$(date +%m)" == 02 ] && [ "$cycle_date" -gt 28 ]
		then
			cycle_date=28
		fi
		cyc_date=$(date -d "$(date +%Y)-$(date +%m)-$cycle_date" +%s)
		if [[ "$cyc_date" -gt "$last_mod_date" ]] && [[ "$cyc_date" -lt "$cur_date" ]]
		then
			rm "$filepath"
		fi
	fi
}


wifi_record_update() {
	availability=""
	for dev in $net_interface
	do
		iw_rep=$(iwconfig "$dev")
		ssid=$(echo "$iw_rep" | grep "ESSID" | cut -d: -f2)
		mac=$(echo "$iw_rep" | grep "Access Point" | tr -s ' ' | cut -d ' ' -f7)
		if [ "$ssid" != "off/any  " ]         #there are 2 spaces after off/any.
		then
			availability="yes"
			if grep -Fq "$mac" "$filepath"
			then
				true
				#used=$(grep "$mac" "$filepath" | cut -d ' ' -f3) # for debugging
			else
				echo "$mac $ssid 0" >> "$filepath"
			fi
			break
		fi
	done
}


###########	main

#####	identifying all wifi network adapter interfaces
net_interface=()
for dev in /sys/class/net/*;
do
	if [ -d "$dev/wireless/" ]
	then
		w_dev=${dev##*/} # removes everything until last / to get only interface name
		net_interface+=("$w_dev")
	fi
done


##### getting cycle date
if [ -f "$filepath" ]
then
	cycle_date=$(head -n 1 "$filepath")
else
	cycle_date=1 #default date at the start of first ever run of this script
fi


##### deletes $filepath file if the cycle date is passed
date_check;

if ! [[ -f "$filepath" ]]
then
	echo "$cycle_date" > "$filepath"
fi


##### main while loop
while true
do
	wifi_record_update
	while [ "$availability" != "" ]
	do
		prev=$cur
		cur=$(cat /sys/class/net/"$dev"/statistics/rx_bytes)
		add=$((cur-prev))
		if  [ "$add" != 0 ]; then
			echo "$(awk -v ad="$add" -v ma="$mac" '{if ($1==ma) {$3=$3+ad}; print $0 }' "$filepath")" > "$filepath" ### updating the used value
		fi
		wifi_record_update
	done
done

exit 0
