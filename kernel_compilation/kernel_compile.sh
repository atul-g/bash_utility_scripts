#!/bin/bash

# default number of cores that would be used for the compilation process
# Change the value below if you don't want to compile kernel in all available cores of the system
CORES=`getconf _NPROCESSORS_ONLN`
kernel_version="$(make kernelversion)"  # the kernel version to install

while getopts 'j' OPTION; do
    case "$OPTION" in
        j)
            CORES="$OPTARG"
            ;;
        ?)
            echo "invalid arguments passed, aborting..."
            exit 1
            ;;
    esac
done

# to clean up  any previous config file
make mrproper 


# This basically takes the currently installed kernel's config file. Note, there could be possible missing packages
# when running the make scripts, you need to install all the required packages before running this script.

# make menuconfig  * A menu oriented way to make your config file
# make xconfig    * this GUI method requires extra packages to be installed
# make defconfig * a very minimal config file. Definetly wouldnt recommend  this.
# make localyesconfig * remember, in your PC the wifi wasn't working when using a kernel using the .config file generated using this command
yes '' | make oldconfig
if [ "$?" != "0" ];
then 
    echo -e "\nError while making .config file. Aborting compilation...";
    exit 1
fi

# to clean the kernel source directory
make clean


# Here we store a temporary data of the currently installed kernel modules in /lib/modules
ls /lib/modules > /tmp/kernel_temp_file


# this starts the compilation process
make -j ${CORES}
if [ "$?" != "0" ];
then 
    echo -e "\nAn error has occured during compilation. Last executed command was: make -j $(CORES)";
    exit 1
fi


# installing modules
sudo make modules_install install

# this pastes the bzImage file generated as the vmlinuz file in /boot.
cp -v arch/x86_64/boot/bzImage /boot/vmlinuz-{kernel_version}

#NOTE: CHANGE THE ABOVE LOCATION BASED ON YOUR ARCH, IT CAN BE AT arch/x86 OR arch/x86_64


if [ "$?" != "0" ];
then 
    echo -e "\nError while copying bzimage to /boot. Check where 'make' stores the kernel and change the 'cp' command in the script accordingly. Aborting compilation...";
    exit 1
fi


# this part is to determine the exact name of the folder where the modules were installed
kernel_modules_dir=$(diff /tmp/kernel_modules_dir `ls /lib/modules` | awk 'NR==2 {print $2}')

# The following code generates the initramfs for the compiled kernel
mkinitcpio -k ${kernel_version} -g /boot/initramfs-${kernel_modules_dir}.img

if [ "$?" != "0" ];
then 
    echo -e "\nError occured while generating initramfs, make sure that the argument passed to -k parameter is the same name as the folder of the installed kernel in '/lib/modules/...'. Aborting process...";
    exit 1
fi


#updating the grub configs
sudo update-grub

# If you want to reboot the system right after installation, uncomment the below line
#sudo reboot now


