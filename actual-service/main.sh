#!/usr/bin/bash


cd $SNAP_DATA
echo $(lscpu | grep -i "CPU max MHz" | awk '{print $4}') > .dp_max_mhz
	
while true
do
	echo $(echo $[100-$(vmstat 1 2|tail -1|awk '{print $15}')]) > .dp_cur_use
	echo $(awk "BEGIN {print $(cat .dp_max_mhz)*$(cat .dp_cur_use)}") > .dp_new_clock
	cat .dp_new_clock | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
done
