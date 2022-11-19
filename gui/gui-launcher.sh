#!/usr/quack/env/bash

CliPrint() {
    echo "Current CPU Use:" $(cat /etc/duckpowered/dp_cur_use.duck) "%"
    echo "Maximum Possible Clock Speed:" $(cat /etc/duckpowered/dp_max_mhz.duck) "mHz"
    echo "DuckPowered's Clock Speed:" $(cat /etc/duckpowered/dp_new_clock.duck) "kHz"
}

FailureCase () {
    echo "It doesn't look like the Graphical Interface is supported on your device!"
    echo "For a more consistant CLI interface, type duckpowered cli into your terminal."
    CliPrint
}
if [ "$1" = "" ]; then
    echo "DuckPowered Graphical Dashboard is based on another software."
    echo "Please type 'duckpowered credits' to learn more."
    $SNAP/usr/bin/dash || FailureCase
elif [ "$1" = "cli" ]; then
    CliPrint
elif [ "$1" = "credits" ]; then
    echo "Thanks to the following people who make DuckPowered a reality:"
    echo "Harvey, Jai, Neve, Alister, Michael and Ms Hin"
    echo "Special shoutout to Zoe and Shalamanda, your fun duck antics kept us going!"
    echo "==========================================================================="
    echo "Legally Required Credits for Open Source Projects we have used:"
    echo "==== Tauri App ==== "
    echo "Thanks to Tauri (https://tauri.app) allowing our HTML GUI to run through GTK"
    echo "It's licensed under Apache 2.0, which you can find here: https://www.apache.org/licenses/LICENSE-2.0"
    echo "We have not modified it."
    echo "==== GaugeSVG  ==== "
    echo "Thanks to GaugeSVG by Steffen Ploetz (https://https://www.codeproject.com/Articles/604502/A-Universal-Gauge-for-Your-Web-Dashboard)"
    echo "This allows the 'CPU Usage' gauge on our dashboard."
    echo "It's licensed under the LGPL, which you an find here: https://www.gnu.org/licenses/lgpl-3.0.en.html"
    echo "We have not modified it."
else
    echo "Error - unknown argument"
fi
