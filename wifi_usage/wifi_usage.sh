
date_check() {
	if [ -f usage ]
	then 
		cur_date=$(date +%s)
		last_mod_date=$(date -r usage +%s)
		if [ $(date +%m) == 02 ] && [ $cycle_date -gt 28 ]
		then
			cycle_date=28
		fi
		cyc_date=$(date -d "$(date +%Y)-$(date +%m)-$cycle_date" +%s)
		if [[ $cyc_date -gt $last_mod_date ]] && [[ $cyc_date -lt $cur_date ]]
		then
			rm usage
		fi
	fi
}


wifi_record_update() {
	availability=""
	for dev in $net_interface
	do
		if [ $(iwconfig wlp0s20f3 | grep ESSID | cut -d: -f2) != "off/any" ]
		then
			availability="yes"
			ssid=$(iwconfig wlp0s20f3 | grep ESSID | cut -d: -f2)
			mac=$(iwconfig wlp0s20f3 | grep "Access Point" | tr -s ' ' | cut -d ' ' -f7)
			if grep -Fq "$mac" usage
			then
				used=$(grep "$mac" usage | cut -d ' ' -f3)
			else
				echo "$mac $ssid 0" >> usage
			fi
			break
		fi
	done
	sed -i "/off\/any/d" usage ###to delete garbage records which sometimes get collected with mac name set as off/any
}


###########	main


#####	identifying all wifi network adapter interfaces
net_interface=()
for dev in $(ls /sys/class/net/);
do
	if [ -d "/sys/class/net/$dev/wireless/" ]
	then
		net_interface+=("$dev")
	fi
done


##### getting cycle date
if [ -f usage ]
then
	cycle_date=$(head -n 1 usage)
else
	cycle_date=1 #default date at the start of first ever run of this script
fi


##### deletes usage file if the cycle date is passed
date_check;


if ! [[ -f usage ]]
then
	echo $cycle_date > usage
fi


##### main while loop
while true
do
	wifi_record_update
	while [ "$availability" != "" ]
	do
		prev=$cur
		cur=$(cat /sys/class/net/$dev/statistics/rx_bytes)
		add=$((cur-prev))
		echo "$(awk -v ad=$add -v ma=$mac '{if ($1==ma) {$3=$3+ad}; print $0 }' usage)" > usage ### updating the used value
		wifi_record_update
	done
done

exit 0
