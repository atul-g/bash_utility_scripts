# Battery Monitor

Battery Monitor is a simple script to send notifications to the user when their laptop has charged over 60%.

### Problem Context
Almost all Laptop Batteries are Lithium-ion based. The capacity of these batteries can detoriate over time - the main reasons being improper charge cycles. Due to such charge cycles, the battery's total capacity can reduce around 10% per year. (For more info on this click [here](https://superuser.com/questions/502328/how-does-limiting-a-laptop-batterys-full-charge-to-less-than-100-extend-its-ba).  

Basically, preventing laptop battery from charging close to it's highest level or discharging close to it's lowest level can help in reducing the detoriation rate of your battery capacity by down to an average of 4% per year. (The ideal charge cycle is from 40% to 60%).  

Unfortunately, there is no automatic way of setting this charge cycle in your laptop unless it's a Lenovo Thinkpad or certain Asus laptops where the Linux Kernel itself allows you to [set charge thresholds](https://www.reddit.com/r/linuxhardware/comments/g8kpee/psa_kernel_54_added_the_ability_to_set_a_battery/). 

Hence the need for a script which automatically notifies you when your battery has charged over 60%, so that you will be reminded to switch off the AC plug manually (doing it manually seems to be the only possible way for now :D ). 


### Usage
1. Make sure you have the package `libnotify-bin` installed, as the script depends on the `notify-send` command to send notifications.
2. In the script, change the value of the variable `DESKTOP_SESSION`. This can depend on the desktop environment of your OS. To find out the proper value, enter `echo $DESKTOP_SESSION` in your terminal and write the output as the value for the same variable in the script.
3. Set a cronjob to start this script at bootup using:
    * `crontab -e`
    * `@reboot /path/to/script.sh`
4. You can also use your OS's startup settings or application to set this script to run at bootup.
