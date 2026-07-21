🚀 AWS EC2 SSH Connect Setup

A lightweight and interactive Bash script to quickly enable Root SSH Login and Password Authentication on AWS EC2 instances running Ubuntu or Debian.

Designed for users who need fast SSH access without manually editing SSH configuration files.

---

✨ Features

- ✅ Enable Root SSH Login
- ✅ Enable Password Authentication
- ✅ Set Root Password
- ✅ Automatically Configure SSH
- ✅ Restart SSH Service
- ✅ Verify SSH Configuration
- ✅ Detect & Display Public IP
- ✅ Interactive Terminal Interface
- ✅ One-Command Installation with "curl"

---

📋 Requirements

- AWS EC2 Instance
- Ubuntu or Debian
- "sudo" privileges
- Internet connection

---

⚡ Quick Install

Run the latest version directly from GitHub:

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

Run the script:

./setup.sh

or

bash setup.sh

---

🛠️ What the Script Does

The script automatically:

- Sets a password for the root user
- Enables Root Login
- Enables Password Authentication
- Creates an SSH override configuration
- Restarts the SSH service
- Verifies the applied SSH configuration
- Detects and displays the server's Public IP

---

🔑 Login After Setup

Use your EC2 Public IP:

Host: YOUR_PUBLIC_IP
Username: root
Password: Your chosen password

Example:

ssh root@YOUR_PUBLIC_IP

---

✅ Tested Platforms

Ubuntu

Version| Status
Ubuntu 18.04 LTS| ✅
Ubuntu 20.04 LTS| ✅
Ubuntu 22.04 LTS| ✅
Ubuntu 24.04 LTS| ✅
Ubuntu 25.04| ✅
Ubuntu 25.10| ✅

Debian

Version| Status
Debian 10 (Buster)| ✅
Debian 11 (Bullseye)| ✅
Debian 12 (Bookworm)| ✅
Debian 13 (Trixie)| ✅

---

📂 Repository Structure

.
├── setup.sh
└── README.md

---

⚠️ Security Notice

This script enables root login using a password, which is intended for testing, development, or environments you control.

For production servers, it is strongly recommended to:

- Use SSH Key Authentication
- Disable Password Authentication
- Disable Root Login after setup
- Protect your server with a firewall

---

📄 License

This project is licensed under the MIT License.

---

⭐ Support

If this project helped you, consider giving the repository a ⭐ Star on GitHub.

Contributions, issues, and pull requests are always welcome.
