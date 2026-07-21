🚀 AWS EC2 SSH Connect Setup

«One-command SSH setup for AWS EC2.
Enable Root Login and Password Authentication on Ubuntu & Debian in seconds.»

<p align="center">"Platform" (https://img.shields.io/badge/Platform-AWS%20EC2-orange?style=for-the-badge)
"OS" (https://img.shields.io/badge/Ubuntu%20%26%20Debian-Supported-success?style=for-the-badge)
"Shell" (https://img.shields.io/badge/Bash-Script-blue?style=for-the-badge)
"License" (https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

</p>---

✨ Features

- 🔐 Enable Root SSH Login
- 🔑 Enable Password Authentication
- 👤 Set Root Password
- ⚡ Automatic SSH Configuration
- 🔄 Restart SSH Service
- 🌐 Detect Public IP Automatically
- 📋 Interactive Menu
- 🚀 One-Command Installation
- ✅ Lightweight & Fast

---

🚀 Quick Install

Run directly without cloning:

bash <(curl -fsSL https://raw.githubusercontent.com/nihent/setups/main/setup.sh)

or

curl -fsSL https://raw.githubusercontent.com/nihent/setups/main/setup.sh | bash

---

📥 Manual Installation

Clone the repository:

git clone https://github.com/nihent/setups.git
cd setups

Make the script executable:

chmod +x setup.sh

Run:

./setup.sh

or

bash setup.sh

---

⚙️ What This Script Does

✔ Sets a password for the root user.

✔ Enables PermitRootLogin.

✔ Enables PasswordAuthentication.

✔ Restarts the SSH service.

✔ Verifies the SSH configuration.

✔ Automatically detects and displays your Public IP.

---

🔑 Login

After setup:

Host : Your EC2 Public IP
User : root
Password : Your chosen password

Example:

ssh root@YOUR_PUBLIC_IP

---

✅ Tested & Working

Ubuntu

- ✅ Ubuntu 18.04 LTS
- ✅ Ubuntu 20.04 LTS
- ✅ Ubuntu 22.04 LTS
- ✅ Ubuntu 24.04 LTS
- ✅ Ubuntu 25.04
- ✅ Ubuntu 25.10

Debian

- ✅ Debian 10 (Buster)
- ✅ Debian 11 (Bullseye)
- ✅ Debian 12 (Bookworm)
- ✅ Debian 13 (Trixie)

Status: 🟢 Fully Tested & Working

---

📋 Requirements

- AWS EC2 Instance
- Ubuntu / Debian
- sudo privileges
- Internet Connection

---

⚠️ Security Notice

This script enables Root Login and Password Authentication.

It is recommended for development, testing, or private servers. If you expose your server to the public internet, always use:

- Strong passwords
- Firewall rules
- SSH Keys (recommended)
- Fail2Ban or similar protection

---

📄 License

Licensed under the MIT License.

---

<p align="center">
Made with ❤️ by <b>Nihent</b>
</p>
