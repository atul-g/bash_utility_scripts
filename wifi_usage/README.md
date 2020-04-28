# WIFI USAGE COUNTER

A script that records all the WIFI usage among different connected Wifi hotspots/routers during every live OS session. The usage is recorded in a monthly basis.

### Files
- `wifi_usage.sh` - the main script which runs right after booting and records all the wifi usage.

- `usage` - the file in which the wifi usage is recorded. The file consists of:
    - `cycle date` - Day of the month when wifi quota gets renewed in the first line.
    - `MAC Address` - MAC Address of all the wifi that has been connected with (stored in the first column).
    - `SSID` - The name of the wifi routers/hotspot (Second column).
    - `USAGE` - Amount of MiBs that have been consumed from the corresponding WIFI (Third column).

- `read_usage.sh` - the file which user can run to view the usage accross all the WIFIs. You can also use this script to change the monthly cycle date.

### Running the scripts

- It is required to make the `wifi_usage.sh` file to run right after bootup. For this we will create a cron job using commands:

	`cron -e /path/to/wifi_usage.sh`

- After setting this, you can run the `read_usage.sh` script to see the wifi usage details.
- To change the cycle date (default is 1): `./read_usage.sh -d <day of month>`. Make sure the date value entered is between 1 and 30.

