# Compiling Linux kernel and installing it from source

This is a script that can be used to compile the Linux Kernel from Linus's repository and install it. This script is suitable only for installation in Arch based distros (tried in Manjaro Linux). Installation of necessary Kernel compilation packages are needed before the execution of this script. Check out the documentation link given below for more info.

## Instructions
1. This script needs to copied right inside the root folder of the kernel repo folder.

2. The script uses `make oldconfig` to make the Kernel configuration files by default (basically uses the .config file of the currently installed kernel in your OS). Uncomment/Change these lines to any other suitable procedure you prefer to make your configuration files.  

3. The scripts uses all available cores to run the make command. Change it if you don't want the scipt to run in all CPU cores.  

4. Usage instructions: **The script requires sudo privileges to execute, so run it by executing command: `sudo ./kernel_compilation`**.

5. Check this [page](https://wiki.archlinux.org/index.php/Kernel/Traditional_compilation) for more info.  
