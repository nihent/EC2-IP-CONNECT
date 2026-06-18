#!/bin/bash

clear

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# ASCII Banner
echo -e "${CYAN}"
echo "_   _      _ _"
echo "| | | | ___| | | ___"
echo "| |_| |/ _ \ | |/ _ \"
echo "|  _  |  __/ | | (_) |"
echo "|_| |_|\___|_|_|\___/"
echo ""
echo "        X HUB HOSTINGER EC2 Setup Tool"
echo -e "${RESET}"

sleep 1

echo "1) Setup SSH (Enable root + password login)"
echo "2) Exit"
echo ""
read -p "Choose option: " choice

if [ "$choice" != "1" ]; then
    echo -e "${RED}Exiting...${RESET}"
    exit 0
fi

echo ""
echo -e "${CYAN}Enter password for ROOT user:${RESET}"
read -s ROOTPASS
echo ""

if [ -z "$ROOTPASS" ]; then
    echo -e "${RED}Password cannot be empty!${RESET}"
    exit 1
fi

echo ""
echo -e "${GREEN}[*] Setting root password...${RESET}"
echo "root:$ROOTPASS" | sudo chpasswd

echo -e "${GREEN}[*] Updating SSH configuration...${RESET}"

# Enable PasswordAuthentication in cloud config
if [ -f /etc/ssh/sshd_config.d/60-cloudimg-settings.conf ]; then
    sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' \
    /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
fi

# Create final override config
echo -e "PermitRootLogin yes\nPasswordAuthentication yes" | \
sudo tee /etc/ssh/sshd_config.d/zzz-final.conf >/dev/null

echo -e "${GREEN}[*] Restarting SSH service...${RESET}"
sudo systemctl restart ssh || sudo systemctl restart sshd

echo -e "${GREEN}[*] Verifying SSH configuration...${RESET}"
sshd -T | grep -E "permitrootlogin|passwordauthentication"

echo ""
echo -e "${GREEN}✔ Setup completed successfully!${RESET}"
echo ""
echo -e "${YELLOW}Login Details:${RESET}"
echo "User: root"
echo "Password: (the password you entered)"
echo ""

# Try getting public IP automatically
PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null)

if [ ! -z "$PUBLIC_IP" ]; then
    echo "IP: $PUBLIC_IP"
else
    echo "IP: Your EC2 Public IP"
fi

echo ""
echo -e "${CYAN}You can now login via SSH using root.${RESET}"
echo ""
