#!/bin/bash

cpu_arch=$(arch)
export cpu_arch
echo "[Quacky] CPU Arch is:" "$cpu_arch"

GuiSupportedBuild () {
    cd "$SNAPCRAFT_PART_INSTALL"
    snap install rustup --classic
    rustup install stable
    rustup default stable
    fallocate -l 8G /buildSwapfile
    chmod 600 /buildSwapfile
    mkswap /buildSwapfile
    swapon /buildSwapfile
    cargo install tauri-cli
    apt -y install libssl-dev
    cargo tauri build -b none
    cp ./src-tauri/target/release/duck-powered-dashboard .
    chmod +x ./duck-powered-dashboard
    rm -r ./src-tauri/target
    cp ./gui-launcher.sh ./actual-gui-launch.sh
    chmod 777 ./actual-gui-launch.sh
}

GuiDeniedBuild () {
    cd "$SNAPCRAFT_PART_INSTALL"
    touch duck-powered-dashboard
    chmod +x ./duck-powered-dashboard
    cp ./pp-gui-launcher.sh ./actual-gui-launch.sh
    chmod 777 ./actual-gui-launch.sh
}

if [ "$cpu_arch" = "x86_64" ]; then
    echo "[Quacky] Gui Supported Build! x86_64"
    GuiSupportedBuild
elif [ "$cpu_arch" == "ARM64" ]; then
    echo "[Quacky] Gui Supported Build! ARM64"
    GuiSupportedBuild
elif [ "$cpu_arch" == "arm64" ]; then
    echo "[Quacky] Gui Supported Build! arm64"
    GuiSupportedBuild
elif [ "$cpu_arch" == "ARMHF" ]; then
    echo "[Quacky] Gui Supported Build! ARMHF"
    GuiSupportedBuild
elif [ "$cpu_arch" == "armhf" ]; then
    echo "[Quacky] Gui Supported Build! armhf"
    GuiSupportedBuild
elif [ "$cpu_arch" == "aarch64" ]; then
    echo "[Quacky] Gui Supported Build! aarch64"
    GuiSupportedBuild
elif [ "$cpu_arch" == "armv7l" ]; then
    echo "[Quacky] Gui Supported Build! armv7l"
    GuiSupportedBuild
else
    echo "[Quacky] Gui is NOT Supported!" "$cpu_arch"
    GuiDeniedBuild
fi




