#!/bin/bash
echo "Installing DuckPowered v0.1a..."
echo "Stage [1/2] Configuring local storage..."
cd $SNAP_USER_DATA/duckpowered || mkdir $SNAP_USER_DATA/duckpowered; cd $SNAP_USER_DATA/duckpowered || exit
echo "Stage [2/2] Checking for intel_pstate..."
duckpoweredi_pstate=$(grep -q active /sys/devices/system/cpu/intel_pstate/status && echo "pstate active !")
duckpoweredi_toxic="pstate active !"
if [ "$duckpoweredi_pstate" = "$duckpoweredi_toxic" ]; then
	    echo "[!] intel_pstate found!"
	    echo "We will now disable the intel_pstate driver as it causes issue with DuckPowered, do you consent [Y/N]?"
	    read -r consent
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
            echo "If you chnage your mind about this disable, please run sudo duckpowered install"
	    fi
else
	echo "intel_pstate not found, you are good to go!"
fi