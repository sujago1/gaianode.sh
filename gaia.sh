#!/bin/bash

printf "\n"
cat <<EOF


░██████╗░░█████╗░  ░█████╗░██████╗░██╗░░░██╗██████╗░████████╗░███[...]
██╔════╝░██╔══██╗  ██╔══██╗██╔══██╗╚██╗░██╔╝██╔══██╗╚══██╔══╝██╔═[...]
██║░░██╗░███████║  ██║░░╚═╝██████╔╝░╚████╔╝░██████╔╝░░░██║░░░██║░[...]
██║░░╚██╗██╔══██║  ██║░░██╗██╔══██╗░░╚██╔╝░░██╔═══╝░░░░██║░░░██║░[...]
╚██████╔╝██║░░██║  ╚█████╔╝██║░░██║░░░██║░░░██║░░░░░░░░██║░░░╚███[...]
░╚═════╝░╚═╝░░╚═╝  ░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░░░░╚═╝░░░░╚══[...]
EOF

printf "\n\n"

##########################################################################################
#
#                🚀 THIS SCRIPT IS PROUDLY CREATED BY **GA CRYPTO**! 🚀
#
#   🌐 Join our revolution in decentralized networks and crypto innovation!
#
# 📢 Stay updated:
#     • Follow us on Telegram: https://t.me/GaCryptOfficial
#     • Follow us on X: https://x.com/GACryptoO
##########################################################################################

# Green color for advertisement
GREEN="\033[0;32m"
RESET="\033[0m"

# Ensure required packages are installed
echo "📦 Installing dependencies..."
sudo apt update -y && sudo apt install -y pciutils libgomp1 curl wget build-essential libglvnd-dev pkg-config libopenblas-dev libomp-dev
sudo apt upgrade -y && sudo apt update

# Detect if running inside WSL
IS_WSL=false
if grep -qi microsoft /proc/version; then
    IS_WSL=true
    echo "🖥️ Running inside WSL."
else
    echo "🖥️ Running on a native Ubuntu system."
fi

# Check if an NVIDIA GPU is present
check_nvidia_gpu() {
    if command -v nvidia-smi &> /dev/null || lspci | grep -i nvidia &> /dev/null; then
        echo "✅ NVIDIA GPU detected."
        return 0
    else
        echo "⚠️ No NVIDIA GPU found."
        return 1
    fi
}

# Check if the system is a VPS, Laptop, or Desktop
check_system_type() {
    vps_type=$(systemd-detect-virt)
    if echo "$vps_type" | grep -qiE "kvm|qemu|vmware|xen|lxc"; then
        echo "✅ This is a VPS."
        return 0  # VPS
    elif ls /sys/class/power_supply/ | grep -q "^BAT[0-9]"; then
        echo "✅ This is a Laptop."
        return 1  # Laptop
    else
        echo "✅ This is a Desktop."
        return 2  # Desktop
    fi
}

# Install GaiaNet with appropriate CUDA support
install_gaianet() {
    echo "⚠️ Installing GaiaNet without GPU support..."
    curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/download/0.4.20/install.sh' | bash || { echo "❌ GaiaNet installation without GPU failed."; exit 1; }
}

# Add GaiaNet to PATH
add_gaianet_to_path() {
    echo 'export PATH=$HOME/gaianet/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
}

# Main logic
install_gaianet

# Verify GaiaNet installation
if [ -f ~/gaianet/bin/gaianet ]; then
    echo "✅ GaiaNet installed successfully."
    add_gaianet_to_path
else
    echo "❌ GaiaNet installation failed. Exiting."
    exit 1
fi

# Determine system type and set configuration URL
check_system_type
SYSTEM_TYPE=$?  # Capture the return value of check_system_type

if [[ $SYSTEM_TYPE -eq 0 ]]; then
    # VPS
    CONFIG_URL="https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config2.json"
elif [[ $SYSTEM_TYPE -eq 1 ]]; then
    # Laptop
    if ! check_nvidia_gpu; then
        CONFIG_URL="https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config2.json"
    else
        CONFIG_URL="https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config1.json"
    fi
elif [[ $SYSTEM_TYPE -eq 2 ]]; then
    # Desktop
    if ! check_nvidia_gpu; then
        CONFIG_URL="https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config2.json"
    else
        CONFIG_URL="https://raw.githubusercontent.com/abhiag/Gaia_Node/main/config3.json"
    fi
fi

# Initialize and start GaiaNet
echo "⚙️ Initializing GaiaNet..."
~/gaianet/bin/gaianet init --config "$CONFIG_URL" || { echo "❌ GaiaNet initialization failed!"; exit 1; }

echo "🚀 Starting GaiaNet node..."
~/gaianet/bin/gaianet config --domain gaia.domains
~/gaianet/bin/gaianet start || { echo "❌ Error: Failed to start GaiaNet node!"; exit 1; }

echo "🔍 Fetching GaiaNet node information..."
~/gaianet/bin/gaianet info || { echo "❌ Error: Failed to fetch GaiaNet node information!"; exit 1; }

# Closing message
echo "==========================================================="
echo "🎉 Congratulations! Your GaiaNet node is successfully set up!"
echo "🌟 Stay connected: Telegram: https://t.me/GaCryptOfficial | Twitter: https://x.com/GACryptoO"
echo "💪 Together, let's build the future of decentralized networks!"
echo "==========================================================="
