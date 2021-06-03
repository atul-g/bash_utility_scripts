#!/bin/bash

set -e

# comment out the date which you don't want to see
today=$(date +%d-%m-%Y)
tomm=$(date -d tomorrow +%d-%m-%Y)
dayafter=$(date -d "+2 days" +%d-%m-%Y)

AGE_18="true"
AGE_45="false"
FIRST_DOSE="true"
SECOND_DOSE="false"

slot_check() {
	day="$2"
	echo "$day"
	AGE="$1"
	first_flag="false"
	second_flag="false"


	curl --user-agent "Mozilla/5.0" "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByDistrict?district_id=571&date=${day}"  >  /tmp/cowin-resp
	list=$(cat /tmp/cowin-resp | jq '.sessions[] | "\(.min_age_limit) \(.available_capacity_dose1) \(.available_capacity_dose2)" ' )

	# adding a " in the grep, to search '"18', this makes sure
	# that it grep 18/45 of first field only which is for age
	# Also, $list here is a global variable
	echo "$list" | grep "\"$AGE" | while read line
	do
		#echo "$line"
		if [ "$FIRST_DOSE" = "true" -a "$first_flag" = "false" ]
		then
			# make sure to get rid of " in the end of each line
			num=$(echo "${line%?}" | awk '{print $2}')
			if [ $num -gt 0 ]
			then
				echo "Date: ${day} - Age ${AGE}: 1st dose available" >> /tmp/cowin-notif-${AGE}-msg
				first_flag="true"
			fi
		fi

		if [ "$SECOND_DOSE" = "true" -a "$second_flag" = "false" ]
		then
			num=$(echo "${line%?}" | awk '{print $3}')
			if [ $num -gt 0 ]
			then
				echo "Day: ${day} - Age ${AGE}: 2nd dose available" >> /tmp/cowin-notif-${AGE}-msg
				second_flag="true"
			fi
		fi
	done
}

# MAIN 

while true
do

	rm -f /tmp/cowin-notif-*

	if [ "$AGE_18" = "true" ]
	then
		if [ -n "$today" ]
		then
			slot_check "18" "$today"
		fi

		if [ -n "$tomm" ]
		then
			slot_check "18" "$tomm"
		fi

		if [ -n "$dayafter" ]
		then
			slot_check "18" "$dayafter"
		fi

		if [ -f /tmp/cowin-notif-18-msg ]
		then
			notify-send -u critical "$(cat /tmp/cowin-notif-18-msg)" 
		fi
	fi


	if [ "$AGE_45" = "true" ]
	then
		if [ -n "$today" ]
		then
			slot_check "45" "$today"
		fi

		if [ -n "$tomm" ]
		then
			slot_check "45" "$tomm"
		fi

		if [ -n "$dayafter" ]
		then
			slot_check "45" "$dayafter"
		fi

		if [ -f /tmp/cowin-notif-45-msg ]
		then
			notify-send -u critical "$(cat /tmp/cowin-notif-45-msg)" 
		fi
	fi

	sleep 1800
done
