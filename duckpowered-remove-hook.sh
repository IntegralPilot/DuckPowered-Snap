#!/bin/bash
echo "Removing DuckPowered v1.0a..."
echo "Stage [1/1] Configuring intel_pstate..."
cd $SNAP_USER_DATA/duckpowered || exit
if [ -f .pstate_disabled ]; then
    echo "It looks like we disabled intel_pstate!"
    echo "Re-enabling it for you..."
    sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT='intel_pstate=disable/GRUB_CMDLINE_LINUX_DEFAULT='/" /etc/default/grub
    set -e
    $SNAP/cargo/root/grub-mkconfig -o /boot/grub/grub.cfg "$@"
    rm .pstate_disabled
    echo "Done!"
else
    echo "We don't need to configure intel_pstate!"
    echo "All done!"
fi
