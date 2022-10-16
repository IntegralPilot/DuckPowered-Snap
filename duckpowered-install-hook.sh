#!/bin/bash
echo "Installing DuckPowered v0.1a..."
$SNAP/cargo/zenity --info --width 300 --text "Welcome to the DuckPowered install wizard. Press 'OK' to continue..."
echo "Stage [1/2] Configuring local storage..."
cd $SNAP_USER_DATA/duckpowered || mkdir $SNAP_USER_DATA/duckpowered; cd $SNAP_USER_DATA/duckpowered || exit
$SNAP/cargo/zenity --info --width 300 --text "All installed! :)"
echo "Done!"