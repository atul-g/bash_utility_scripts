#!/bin/bash

### for crontab:
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# we wait until plasma has created it's proc, this will be used later on
# to get the DBUS_SESSION_BUS_ADDRESS env variable mainly
while [ "$(pgrep $DESKTOP_SESSION -n -U $UID)" = "" ]; do
    sleep 5
done

export $(xargs -0 -a "/proc/$(pgrep $DESKTOP_SESSION -n -U $UID)/environ")
# the above line is used to import all the env variables for the desktop
# session which notify-send needs to know as it is a GUI tool

### crontab specific end

notif_displayed=false

msg=$(echo "Battery charge is over 60%. Please turn the AC power off.")
icon="/usr/share/icons/breeze-dark/devices/64/battery.svg"

while true; do
    if [ "$(cat /sys/class/power_supply/BAT1/capacity)" -ge 60 -a "$(cat /sys/class/power_supply/BAT1/status)" = "Charging"  -a "$notif_displayed" = false ]; then
        notify-send "$msg" -u critical -i "$icon"
        notif_displayed=true
    fi

    if [ "$(cat /sys/class/power_supply/BAT1/capacity)" -lt 60 ]; then
        notif_displayed=false
    fi

    sleep 60
done
