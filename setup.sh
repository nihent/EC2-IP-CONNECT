```bash
#!/bin/bash

# ==========================================
# AWS EC2 SSH CONNECT SETUP
# ==========================================

clear

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
RESET='\033[0m'

# Banner
echo -e "${CYAN}"
cat << 'EOF'
    _   _ _ _            _
   | \ | (_) |__   ___  | |_
   |  \| | | '_ \ / _ \ | __|
   | |\  | | | | |  __/ | |_
   |_| \_|_|_| |_|\___|  \__|
EOF

echo -e "${RESET}"
echo -e "${WHITE}       AWS EC2 SSH CONNECT SETUP${RESET}"
echo -e "${GRAY}       Root Access Configuration${RESET}"
echo ""
echo -e "${GRAY}------------------------------------------${RESET}"
echo ""

# Menu
echo -e "  ${GREEN}[1]${RESET} Setup SSH"
echo -e "  ${RED}[2]${RESET} Exit"
echo ""
echo -e "${GRAY}------------------------------------------${RESET}"
echo ""

read -rp "$(echo -e "${CYAN}  Select an option: ${RESET}")" choice

if [[ "$choice" != "1" ]]; then
    echo ""
    echo -e "${YELLOW}  Exiting setup...${RESET}"
    exit 0
fi

# Root password
echo ""
echo -e "${WHITE}  Root Password Configuration${RESET}"
echo -e "${GRAY}------------------------------------------${RESET}"
echo ""

read -rsp "$(echo -e "${CYAN}  Enter new root password: ${RESET}")" ROOTPASS
echo ""

if [[ -z "$ROOTPASS" ]]; then
    echo -e "${RED}  Error: Password cannot be empty.${RESET}"
    exit 1
fi

# Check privileges
if [[ $EUID -ne 0 ]] && ! command -v sudo >/dev/null 2>&1; then
    echo -e "${RED}  Error: Root privileges or sudo are required.${RESET}"
    exit 1
fi

# Command wrapper
run() {
    if [[ $EUID -eq 0 ]]; then
        "$@"
    else
        sudo "$@"
    fi
}

echo ""
echo -e "${GRAY}------------------------------------------${RESET}"
echo ""

# Set root password
echo -e "${GREEN}  [1/4]${RESET} Configuring root password..."
if ! printf 'root:%s\n' "$ROOTPASS" | run chpasswd; then
    echo -e "${RED}  Failed to set root password.${RESET}"
    unset ROOTPASS
    exit 1
fi
unset ROOTPASS

# Configure SSH
echo -e "${GREEN}  [2/4]${RESET} Updating SSH configuration..."

if [[ -f /etc/ssh/sshd_config.d/60-cloudimg-settings.conf ]]; then
    run sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' \
        /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
fi

# Create SSH override
printf '%s\n' \
    'PermitRootLogin yes' \
    'PasswordAuthentication yes' |
    run tee /etc/ssh/sshd_config.d/zzz-final.conf >/dev/null

# Validate SSH configuration
echo -e "${GREEN}  [3/4]${RESET} Validating SSH configuration..."

if ! run sshd -t; then
    echo -e "${RED}  SSH configuration validation failed.${RESET}"
    exit 1
fi

# Restart SSH
echo -e "${GREEN}  [4/4]${RESET} Restarting SSH service..."

if ! run systemctl restart ssh 2>/dev/null &&
   ! run systemctl restart sshd 2>/dev/null; then
    echo -e "${RED}  Failed to restart SSH service.${RESET}"
    exit 1
fi

echo ""
echo -e "${GRAY}------------------------------------------${RESET}"
echo -e "${GREEN}  SSH configuration completed!${RESET}"
echo -e "${GRAY}------------------------------------------${RESET}"

# Public IP
PUBLIC_IP=$(curl -4 -fsS --max-time 5 https://checkip.amazonaws.com 2>/dev/null || true)

echo ""
echo -e "${WHITE}  SERVER INFORMATION${RESET}"
echo ""
echo -e "  ${CYAN}Public IP:${RESET} ${PUBLIC_IP:-Not detected}"
echo -e "  ${CYAN}Username:${RESET} root"
echo -e "  ${CYAN}SSH Port:${RESET} 22"
echo ""
echo -e "${GRAY}------------------------------------------${RESET}"
echo ""
echo -e "${YELLOW}  SSH Login Command${RESET}"
echo ""

if [[ -n "$PUBLIC_IP" ]]; then
    echo -e "  ${WHITE}ssh root@${PUBLIC_IP}${RESET}"
else
    echo -e "  ${WHITE}ssh root@YOUR_PUBLIC_IP${RESET}"
fi

echo ""
echo -e "${GRAY}------------------------------------------${RESET}"
echo ""
echo -e "${CYAN}  Make sure your EC2 Security Group allows${RESET}"
echo -e "${CYAN}  inbound SSH connections on port 22.${RESET}"
echo ""
