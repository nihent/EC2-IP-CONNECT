#!/bin/bash

clear

# ==========================================
# COLORS
# ==========================================

RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
WHITE="\033[1;37m"
GRAY="\033[0;90m"
RESET="\033[0m"

LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ==========================================
# ASCII BANNER
# ==========================================

echo -e "${CYAN}"
cat << 'EOF'
 _   _      _ _
| | | | ___| | | ___
| |_| |/ _ \ | |/ _ \
|  _  |  __/ | | (_) |
|_| |_|\___|_|_|\___/
EOF

echo -e "${RESET}"
echo -e "${WHITE}       AWS EC2 SSH CONNECT SETUP${RESET}"
echo -e "${GRAY}          UNIVERSAL LINUX${RESET}"
echo ""
echo -e "${GRAY}${LINE}${RESET}"
echo ""

# ==========================================
# OS DETECTION
# ==========================================

if [ "$(uname -s)" != "Linux" ]; then
    echo -e "${RED}This script requires Linux.${RESET}"
    exit 1
fi

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_ID="$ID"
    OS_NAME="$PRETTY_NAME"
    OS_VERSION="$VERSION_ID"
else
    OS_ID="unknown"
    OS_NAME="Unknown Linux"
    OS_VERSION="unknown"
fi

# ==========================================
# PACKAGE MANAGER DETECTION
# ==========================================

if command -v apt-get >/dev/null 2>&1; then
    PKG_MANAGER="APT"
elif command -v dnf >/dev/null 2>&1; then
    PKG_MANAGER="DNF"
elif command -v yum >/dev/null 2>&1; then
    PKG_MANAGER="YUM"
elif command -v pacman >/dev/null 2>&1; then
    PKG_MANAGER="PACMAN"
elif command -v zypper >/dev/null 2>&1; then
    PKG_MANAGER="ZYPPER"
elif command -v apk >/dev/null 2>&1; then
    PKG_MANAGER="APK"
elif command -v emerge >/dev/null 2>&1; then
    PKG_MANAGER="PORTAGE"
else
    PKG_MANAGER="UNKNOWN"
fi

# ==========================================
# SERVICE MANAGER DETECTION
# ==========================================

if command -v systemctl >/dev/null 2>&1; then
    SERVICE_MANAGER="SYSTEMD"
elif command -v rc-service >/dev/null 2>&1; then
    SERVICE_MANAGER="OPENRC"
elif command -v service >/dev/null 2>&1; then
    SERVICE_MANAGER="SYSVINIT"
else
    SERVICE_MANAGER="UNKNOWN"
fi

# ==========================================
# DISPLAY SYSTEM INFORMATION
# ==========================================

echo -e "${WHITE}SYSTEM INFORMATION${RESET}"
echo ""
echo -e "  ${GRAY}Operating System :${RESET} ${CYAN}${OS_NAME}${RESET}"
echo -e "  ${GRAY}OS ID            :${RESET} ${CYAN}${OS_ID}${RESET}"
echo -e "  ${GRAY}Version          :${RESET} ${CYAN}${OS_VERSION}${RESET}"
echo -e "  ${GRAY}Package Manager  :${RESET} ${CYAN}${PKG_MANAGER}${RESET}"
echo -e "  ${GRAY}Service Manager  :${RESET} ${CYAN}${SERVICE_MANAGER}${RESET}"

echo ""
echo -e "${GRAY}${LINE}${RESET}"
echo ""

# ==========================================
# MAIN MENU
# ==========================================

echo -e "  ${GREEN}[1]${RESET} Setup SSH"
echo -e "  ${RED}[2]${RESET} Exit"

echo ""
echo -e "${GRAY}${LINE}${RESET}"
echo ""

read -p "$(echo -e "${CYAN}  Choose option: ${RESET}")" choice

if [ "$choice" != "1" ]; then
    echo ""
    echo -e "${YELLOW}  Exiting...${RESET}"
    exit 0
fi

# ==========================================
# PRIVILEGE DETECTION
# ==========================================

if [ "$EUID" -eq 0 ]; then
    SUDO=""
else
    if ! command -v sudo >/dev/null 2>&1; then
        echo -e "${RED}Root privileges or sudo are required.${RESET}"
        exit 1
    fi

    SUDO="sudo"
fi

# ==========================================
# ROOT PASSWORD
# ==========================================

echo ""
echo -e "${WHITE}ROOT PASSWORD CONFIGURATION${RESET}"
echo -e "${GRAY}${LINE}${RESET}"
echo ""

read -s -p "$(echo -e "${CYAN}  Enter password for ROOT user: ${RESET}")" ROOTPASS
echo ""

if [ -z "$ROOTPASS" ]; then
    echo -e "${RED}Password cannot be empty!${RESET}"
    exit 1
fi

# ==========================================
# SSH BINARY DETECTION
# ==========================================

SSHD=$(command -v sshd 2>/dev/null)

if [ -z "$SSHD" ]; then
    for path in \
        /usr/sbin/sshd \
        /sbin/sshd \
        /usr/local/sbin/sshd \
        /usr/lib/openssh/sshd
    do
        if [ -x "$path" ]; then
            SSHD="$path"
            break
        fi
    done
fi

if [ -z "$SSHD" ]; then
    echo -e "${RED}OpenSSH server (sshd) is not installed.${RESET}"
    echo -e "${YELLOW}Install the SSH server for your distribution first.${RESET}"
    unset ROOTPASS
    exit 1
fi

# ==========================================
# SSH CONFIGURATION FILE
# ==========================================

MAIN_CONFIG="/etc/ssh/sshd_config"

if [ ! -f "$MAIN_CONFIG" ]; then
    echo -e "${RED}SSH configuration file not found:${RESET}"
    echo "$MAIN_CONFIG"
    unset ROOTPASS
    exit 1
fi

# ==========================================
# SET ROOT PASSWORD
# ==========================================

echo ""
echo -e "${GRAY}${LINE}${RESET}"
echo ""

echo -e "${GREEN}[1/5]${RESET} Setting root password..."

if ! printf 'root:%s\n' "$ROOTPASS" | $SUDO chpasswd; then
    echo -e "${RED}Failed to set root password.${RESET}"
    unset ROOTPASS
    exit 1
fi

unset ROOTPASS

# ==========================================
# BACKUP SSH CONFIGURATION
# ==========================================

echo -e "${GREEN}[2/5]${RESET} Backing up SSH configuration..."

BACKUP="${MAIN_CONFIG}.backup.$(date +%Y%m%d%H%M%S)"

if ! $SUDO cp -p "$MAIN_CONFIG" "$BACKUP"; then
    echo -e "${RED}Failed to create SSH backup.${RESET}"
    exit 1
fi

# ==========================================
# UPDATE SSH CONFIGURATION
# ==========================================

echo -e "${GREEN}[3/5]${RESET} Updating SSH configuration..."

TEMP_CONFIG=$(mktemp) || exit 1

# Set global directives before Include statements.
# Existing global directives are removed.
# Match-specific directives are preserved.

if ! awk '
BEGIN {
    print "PermitRootLogin yes"
    print "PasswordAuthentication yes"
    print ""
    in_match = 0
}

/^[[:space:]]*Match([[:space:]]|$)/ {
    in_match = 1
}

{
    if (!in_match &&
        $0 ~ /^[[:space:]]*(PermitRootLogin|PasswordAuthentication)[[:space:]]+/) {
        next
    }

    print
}
' "$MAIN_CONFIG" > "$TEMP_CONFIG"; then
    rm -f "$TEMP_CONFIG"
    echo -e "${RED}Failed to update SSH configuration.${RESET}"
    exit 1
fi

if ! $SUDO tee "$MAIN_CONFIG" < "$TEMP_CONFIG" >/dev/null; then
    rm -f "$TEMP_CONFIG"
    echo -e "${RED}Failed to write SSH configuration.${RESET}"
    exit 1
fi

rm -f "$TEMP_CONFIG"

# ==========================================
# VALIDATE SSH CONFIGURATION
# ==========================================

echo -e "${GREEN}[4/5]${RESET} Validating SSH configuration..."

if ! $SUDO "$SSHD" -t -f "$MAIN_CONFIG"; then

    echo -e "${RED}SSH configuration validation failed!${RESET}"
    echo -e "${YELLOW}Restoring previous configuration...${RESET}"

    $SUDO cp -p "$BACKUP" "$MAIN_CONFIG"

    exit 1
fi

# Verify effective settings
SSH_SETTINGS=$($SUDO "$SSHD" -T -f "$MAIN_CONFIG" 2>/dev/null)

if ! echo "$SSH_SETTINGS" | grep -qx 'permitrootlogin yes' ||
   ! echo "$SSH_SETTINGS" | grep -qx 'passwordauthentication yes'; then

    echo -e "${RED}Requested SSH settings are not effective.${RESET}"
    echo -e "${YELLOW}Check included configuration files and Match rules.${RESET}"
    echo -e "${YELLOW}Backup: ${BACKUP}${RESET}"

    exit 1
fi

# ==========================================
# RESTART SSH SERVICE
# ==========================================

echo -e "${GREEN}[5/5]${RESET} Restarting SSH service..."

restart_ssh() {

    case "$SERVICE_MANAGER" in

        SYSTEMD)
            $SUDO systemctl restart ssh 2>/dev/null && return 0
            $SUDO systemctl restart sshd 2>/dev/null && return 0
            ;;

        OPENRC)
            $SUDO rc-service sshd restart 2>/dev/null && return 0
            $SUDO rc-service ssh restart 2>/dev/null && return 0
            ;;

        SYSVINIT)
            $SUDO service ssh restart 2>/dev/null && return 0
            $SUDO service sshd restart 2>/dev/null && return 0
            ;;

    esac

    return 1
}

if ! restart_ssh; then
    echo -e "${RED}Failed to restart SSH service.${RESET}"
    echo -e "${YELLOW}Previous configuration backup: ${BACKUP}${RESET}"
    exit 1
fi

# ==========================================
# PUBLIC IP DETECTION
# ==========================================

PUBLIC_IP=""

if command -v curl >/dev/null 2>&1; then
    PUBLIC_IP=$(curl -4 -fsS --max-time 8 \
        https://checkip.amazonaws.com 2>/dev/null)
fi

if [ -z "$PUBLIC_IP" ] && command -v wget >/dev/null 2>&1; then
    PUBLIC_IP=$(wget -4 -qO- \
        --timeout=8 https://checkip.amazonaws.com 2>/dev/null)
fi

# ==========================================
# SUCCESS SCREEN
# ==========================================

echo ""
echo -e "${GRAY}${LINE}${RESET}"
echo ""
echo -e "             ${GREEN}✔ SUCCESS${RESET}"
echo -e "       ${WHITE}SSH SETUP COMPLETED${RESET}"
echo ""
echo -e "${GRAY}${LINE}${RESET}"

# ==========================================
# SERVER INFORMATION
# ==========================================

echo ""
echo -e "${WHITE}SERVER INFORMATION${RESET}"
echo ""

echo -e "  ${GRAY}Operating System :${RESET} ${CYAN}${OS_NAME}${RESET}"
echo -e "  ${GRAY}Username         :${RESET} ${CYAN}root${RESET}"
echo -e "  ${GRAY}Password         :${RESET} ${CYAN}Configured${RESET}"
echo -e "  ${GRAY}Public IP        :${RESET} ${CYAN}${PUBLIC_IP:-Not detected}${RESET}"
echo -e "  ${GRAY}SSH Port         :${RESET} ${CYAN}22${RESET}"

echo ""
echo -e "${GRAY}${LINE}${RESET}"

# ==========================================
# SSH LOGIN COMMAND
# ==========================================

echo ""
echo -e "${YELLOW}SSH CONNECTION COMMAND${RESET}"
echo ""

if [ -n "$PUBLIC_IP" ]; then
    echo -e "  ${WHITE}ssh root@${PUBLIC_IP}${RESET}"
else
    echo -e "  ${WHITE}ssh root@YOUR_PUBLIC_IP${RESET}"
fi

echo ""
echo -e "${GRAY}${LINE}${RESET}"
echo ""

echo -e "${CYAN}Make sure inbound SSH port 22 is allowed${RESET}"
echo -e "${CYAN}in your firewall and cloud security rules.${RESET}"

echo ""
echo -e "${GRAY}Configuration backup: ${BACKUP}${RESET}"
echo ""
