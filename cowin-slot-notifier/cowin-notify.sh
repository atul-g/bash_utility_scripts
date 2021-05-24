#!/bin/bash

set -e

tomm=$(date -d tomorrow +%d-%m-%Y)

curl --user-agent "Mozilla/5.0" "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByDistrict?district_id=571&date=${tomm}"  >  /tmp/cowin-resp

list=$(cat /tmp/cowin-resp | jq '.sessions[] | "\(.min_age_limit) \(.available_capacity_dose1) \(.available_capacity_dose2)" ' )

echo "$list" | grep 18

#temp=$(grep 'available_capacity' /tmp/cowin-resp | head -n 1)
#temp=$( echo "${temp: : -1}" )
#num=$(echo $temp | awk '{print $2}')
#
#if [ $num -gt 0 ]
#then
#	notify-send "VACCINE SLOT AVAILABLE"
#fi
