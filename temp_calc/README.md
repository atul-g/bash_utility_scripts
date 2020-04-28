# TEMP CHECK
A script to check the CPU temperature while doing a stress test.

### DEPENDENCIES:
This script needs the `stress` package. Install it using `sudo apt install stress`. 

### USAGE:
- One of the main uses of this script is to check if there is any temperature drop after performing undervolt on your CPU. Run this script before and after Undervolt to compare the average temperatures and see if undervolt has reduced your CPU temperatures or not.
- USE: `./temp_calc.sh [-c <value> ] [-t <value>]"`
- `c` stands for number of CPU cores on which you want to put your load. Default value is 4.
- `t` stands for time, the duration in seconds you want to run the stress test. Default value is 30s.

#### PS:
Use [undervolt](https://github.com/georgewhewell/undervolt) if you want to undervolt your CPU and even GPU.
