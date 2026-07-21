<div align="center">

# 🚀 AWS EC2 SSH Connect Setup

**Interactive SSH Setup Script for AWS EC2 (Ubuntu & Debian)**

Enable **Root Login** and **Password Authentication** in seconds.

![Platform](https://img.shields.io/badge/Platform-AWS%20EC2-orange?style=for-the-badge)
![Ubuntu](https://img.shields.io/badge/Ubuntu-18.04%20--%2025.10-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Debian](https://img.shields.io/badge/Debian-10%20--%2013-A81D33?style=for-the-badge&logo=debian&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

</div>

---

# ✨ Features

- 🔐 Enable Root Login
- 🔑 Enable Password Authentication
- 👤 Set Root Password
- 🌐 Detect Public IP Automatically
- 🔄 Restart SSH Service
- ✅ Verify SSH Configuration
- ⚡ One Command Installation
- 🖥️ Interactive Menu

---

# ⚡ Quick Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/nihent/setups/main/setup.sh)
```

or

```bash
curl -fsSL https://raw.githubusercontent.com/nihent/setups/main/setup.sh | bash
```

---

# 📥 Manual Installation

```bash
git clone https://github.com/nihent/setups.git
cd setups
chmod +x setup.sh
./setup.sh
```

---

# 📖 Usage

Run the script.

```bash
./setup.sh
```

Choose:

```
1) Setup SSH
2) Exit
```

Enter a password for the **root** user.

Done! 🎉

---

# 🛠️ What it Configures

✔ Sets the Root Password

✔ Enables Root Login

✔ Enables Password Authentication

✔ Creates SSH Override Config

✔ Restarts SSH Service

✔ Displays Public IP

✔ Verifies Configuration

---

# 🔑 Login

```text
Host: YOUR_PUBLIC_IP
Username: root
Password: Your Password
```

Example

```bash
ssh root@YOUR_PUBLIC_IP
```

---

# ✅ Tested

| OS | Status |
|----|--------|
| Ubuntu 18.04 LTS | ✅ |
| Ubuntu 20.04 LTS | ✅ |
| Ubuntu 22.04 LTS | ✅ |
| Ubuntu 24.04 LTS | ✅ |
| Ubuntu 25.04 | ✅ |
| Ubuntu 25.10 | ✅ |
| Debian 10 | ✅ |
| Debian 11 | ✅ |
| Debian 12 | ✅ |
| Debian 13 | ✅ |

---

# 📂 Repository

```
.
├── setup.sh
└── README.md
```

---

# ⚠️ Security

This script enables **Root Login** and **Password Authentication**.

Recommended for:

- Development
- Testing
- Private Servers

For production:

- SSH Keys
- Disable Root Login
- Disable Password Authentication

---

# 📜 License

MIT License

---

<div align="center">

⭐ **If this project helped you, don't forget to Star the repository!**

Made with ❤️ by **Nihent**

</div>
