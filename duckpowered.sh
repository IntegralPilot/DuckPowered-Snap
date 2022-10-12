#!/bin/bash
if [ "$1" = "start" ]; then
underpowered_devicecores=$($SNAP/cargo/getconf _NPROCESSORS_ONLN)
underpowered_activecores=$($SNAP/cargo/getconf _NPROCESSORS_ONLN)
echo "DEVICECORES " "$underpowered_devicecores"
underpowered_turnoff_now="0"
underpowered_max_freq=$($SNAP/cargo/lscpu | grep -i "CPU max MHz" | awk '{print $4}')
underpowered_min_freq=$($SNAP/cargo/lscpu | grep -i "CPU min MHz" | awk '{print $4}')
$SNAP/cargo/root/modprobe cpufreq_userspace
for i in $(seq "$underpowered_devicecores")
do
	underpowered_shutdownpath_part1="/sys/devices/system/cpu/cpu"
	underpowered_shutdownpath_part2="/cpufreq/scaling_governor"
	underpowered_totalshutdownpath=$(echo $underpowered_shutdownpath_part1$underpowered_turnoff_now$underpowered_shutdownpath_part2)
	underpowered_turnoff_now=$(expr "$underpowered_turnoff_now" + 1)
	echo "userspace" > "$underpowered_totalshutdownpath"
done
#RUN EVERY TIME
while true
do
	echo "this keeps going on and on and on"
	echo  "$underpowered_activecores"
	underpowered_currentusage=$(echo "$[100-$($SNAP/cargo/vmstat 1 2|tail -1|awk '{print $15}')]")
	underpowered_magicint=$(expr "$underpowered_currentusage" \* "$underpowered_activecores" / 30)
	underpowered_magicint2=$(echo $(( `echo "$underpowered_magicint"|cut -f1 -d"."` + 1 )))
	if [ "$underpowered_magicint2" -gt  "$underpowered_activecores" ]
	then
		underpowered_turnon=$(expr "$underpowered_magicint2" - "$underpowered_activecores")
		underpowered_turnoff_now="0"
		for i in $(seq "$underpowered_turnon")
		do
			echo "turnon"
			underpowered_shutdownpath_part1="/sys/devices/system/cpu/cpu"
			underpowered_shutdownpath_part2="/cpufreq/scaling_max_freq"
			underpowered_totalshutdownpath=$(echo $underpowered_shutdownpath_part1$underpowered_turnoff_now$underpowered_shutdownpath_part2)
			echo "$underpowered_max_freq" > "$underpowered_totalshutdownpath"
			underpowered_turnoff_now=$(expr "$underpowered_turnoff_now" + 1)
			underpowered_activecores=$(expr "$underpowered_activecores" + 1)
		done
	else
		underpowered_to_turnoff=$(expr "$underpowered_activecores" - "$underpowered_magicint2")
		underpowered_turnoff_now="0"
		for i in $(seq "$underpowered_to_turnoff")
		do
			echo "turnoff"
			underpowered_shutdownpath_part1="/sys/devices/system/cpu/cpu"
			underpowered_shutdownpath_part2="/cpufreq/scaling_max_freq"
			underpowered_totalshutdownpath=$(echo $underpowered_shutdownpath_part1$underpowered_turnoff_now$underpowered_shutdownpath_part2)
			echo "$underpowered_min_freq" > "$underpowered_totalshutdownpath"
			underpowered_turnoff_now=$(expr "$underpowered_turnoff_now" + 1)
			underpowered_activecores=$(expr "$underpowered_activecores" - 1)
		done
	fi
	if [ "$underpowered_currentusage" == 0 ]
	then
		underpowered_currentusage=1
	fi
	underpowered_preclock_decrease=$(echo "40"/"$underpowered_currentusage" | $SNAP/cargo/bc -l)
	underpowered_preclock_decrease=$(echo $(( `echo "$underpowered_preclock_decrease"|cut -f1 -d"."` + 1 )))
	if [ "$underpowered_preclock_decrease" -gt "0" ]
	then
		underpowered_current_clock_speed=$(cat "/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq")
		underpowered_preclock_decrease=$(echo "$underpowered_preclock_decrease"/100 | $SNAP/cargo/bc -l)
		underpowered_clock_decrease=$(echo "$underpowered_preclock_decrease"\*"$underpowered_current_clock_speed" | $SNAP/cargo/bc)
		underpowered_new_clock_speed=$(echo "$underpowered_current_clock_speed"-"$underpowered_clock_decrease" | $SNAP/cargo/bc)
		underpowered_new_clock_speed_decrease=$(echo $(( `echo "$underpowered_new_clock_speed"|cut -f1 -d"."` + 1 )))
		underpowered_turnoff_now="0"
		for i in $(seq "$underpowered_activecores")
		do
			echo "Clock" $underpowered_clock_decrease + "new " + $underpowered_new_clock_speed
			echo "REALCLOCK " $underpowered_current_clock_speed
			underpowered_shutdownpath_part1="/sys/devices/system/cpu/cpu"
			underpowered_shutdownpath_part2="/cpufreq/scaling_max_freq"
			underpowered_totalshutdownpath=$(echo $underpowered_shutdownpath_part1$underpowered_turnoff_now$underpowered_shutdownpath_part2)
			echo "$underpowered_new_clock_speed" > "$underpowered_totalshutdownpath"
			underpowered_turnoff_now=$(expr "$underpowered_turnoff_now" + 1)
		done
	else
		underpowered_preclock_decrease=$(("$underpowered_preclock_decrease" + 1))
		underpowered_current_clock_speed=$(cat "/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq")
		underpowered_clock_decrease=$(echo "$underpowered_preclock_decrease"\*"$underpowered_current_clock_speed | $SNAP/cargo/bc")
		underpowered_new_clock_speed=$(echo $(( `echo "$underpowered_preclock_decrease"|cut -f1 -d"."` + 1 )))
		for i in $(seq "$underpowered_activecores")
		do
			echo "Clock" $underpowered_clock_decrease + "new " + $underpowered_new_clock_speed
			echo "REALCLOCK " $underpowered_current_clock_speed
			underpowered_shutdownpath_part1="/sys/devices/system/cpu/cpu"
			underpowered_shutdownpath_part2="/cpufreq/scaling_max_freq"
			underpowered_totalshutdownpath=$(echo $underpowered_shutdownpath_part1$underpowered_turnoff_now$underpowered_shutdownpath_part2)
			echo "$underpowered_new_clock_speed" > "$underpowered_totalshutdownpath"
			underpowered_turnoff_now=$(expr "$underpowered_turnoff_now" + 1)

		done
	fi
done
elif [ "$1" = "install" ]; then 
echo "Installing DuckPowered v0.1a..."
$SNAP/cargo/zenity --info --width 300 --text "Welcome to the DuckPowered install wizard. Press 'OK' to continue..."
echo "Stage [1/2] Configuring local storage..."
cd $SNAP_USER_DATA/duckpowered || mkdir $SNAP_USER_DATA/duckpowered; cd $SNAP_USER_DATA/duckpowered || exit
echo "Stage [2/2] Checking for intel_pstate..."
duckpoweredi_pstate=$(grep -q active /sys/devices/system/cpu/intel_pstate/status && echo "pstate active !")
duckpoweredi_toxic="pstate active !"
if [ "$duckpoweredi_pstate" = "$duckpoweredi_toxic" ]; then
	    echo "[!] intel_pstate found!"
	    echo "We will now disable the intel_pstate driver as it causes issue with DuckPowered, do you consent [Y/N]?"
		if [ x$DISPLAY != x ] ; then
  			echo "GUI Enabled"
			$SNAP/cargo/zenity --info --width 300 --text "We found a driver called intel_pstate. It causes issues with DuckPowered. Press OK to continue."
		
			if $SNAP/cargo/zenity --question --width 300 --text "Do you consent to disabling this driver? We will modify the kernel boot line."; then
				consent="y"
			else
				consent="n"
			fi
		else
			read -r consent
		fi
	    if [ "$consent" = "y" ]; then
		    echo "Okay then!"
		    sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT='/&intel_pstate=disable /" /etc/default/grub
		    touch .pstate_disabled #note the disable for a future uninstall program
		    set -e
            $SNAP/cargo/root/grub-mkconfig -o /boot/grub/grub.cfg "$@"
	    elif [ "$consent" = "Y" ]; then
		    echo Okay then!
		    sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT='/&intel_pstate=disable /" /etc/default/grub
		    touch .pstate_disabled #note the disable for a future uninstall program
		    set -e
            $SNAP/cargo/root/grub-mkconfig -o /boot/grub/grub.cfg "$@"
	    else
		    echo "Aborting intel_pstate disable. Note that DuckPowered may not function properly (or at all) without this disable."
            echo "If you change your mind about this disable, please run sudo duckpowered install"
			$SNAP/cargo/zenity --info --text "Aborting intel_pstate disable. Note that DuckPowered may not function properly (or at all) without this disable."
			$SNAP/cargo/zenity --info --text  "If you change your mind about this disable, please run sudo duckpowered install"
	    fi
else
	echo "intel_pstate not found, you are good to go!"
	$SNAP/cargo/zenity --info --width 300 --text "All installed! :)"
fi
else
    echo "DuckPowered is running in the background right now!"
fi


