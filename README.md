 <div align="center">

# AWS EC2 SSH Setup

**A simple interactive SSH configuration script for AWS EC2 instances.**

Configure SSH access on Ubuntu and Debian with a single command.

![AWS EC2](https://img.shields.io/badge/AWS-EC2-orange?style=flat-square&logo=amazonaws)
![Ubuntu](https://img.shields.io/badge/Ubuntu-18.04--25.10-E95420?style=flat-square&logo=ubuntu&logoColor=white)
![Debian](https://img.shields.io/badge/Debian-10--13-A81D33?style=flat-square&logo=debian&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)

</div>

---

## Overview

An interactive Bash script that simplifies SSH configuration on AWS EC2 instances.

It provides options to configure root access, password authentication, and SSH settings without manually editing configuration files.

## Features

- Enable root login
- Enable password authentication
- Set the root password
- Automatically detect the public IP address
- Configure SSH override settings
- Restart the SSH service
- Verify SSH configuration
- Interactive terminal menu
- One-command installation

## Quick Installation

Run the following command on your EC2 instance:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/nihent/setups/main/setup.sh)
```

Alternatively:

```bash
curl -fsSL https://raw.githubusercontent.com/nihent/setups/main/setup.sh | bash
```

## Manual Installation

Clone the repository and execute the setup script:

```bash
git clone https://github.com/nihent/setups.git
cd setups
chmod +x setup.sh
./setup.sh
```

## Usage

Start the script:

```bash
./setup.sh
```

Select an option from the interactive menu:

```text
  1) Setup SSH
  2) Exit
```

Choose **Setup SSH**, then enter your desired root password when prompted.

The script applies the configuration and verifies the SSH settings.

## Configuration

The script handles the following operations:

| Configuration | Action |
|---|---|
| Root Password | Sets a new password |
| Root Login | Enables root SSH access |
| Password Authentication | Enables password-based SSH |
| SSH Configuration | Creates an override configuration |
| SSH Service | Restarts the SSH service |
| Public IP | Automatically detects the public IP |
| Verification | Checks applied SSH settings |

## Connecting to Your Server

After successful configuration, connect using:

```bash
ssh root@YOUR_PUBLIC_IP
```

Connection details:

```text
Host:     YOUR_PUBLIC_IP
Username: root
Password: YOUR_ROOT_PASSWORD
```

Replace `YOUR_PUBLIC_IP` with your EC2 instance's public IPv4 address.

**Note:** Your EC2 security group must allow inbound SSH traffic on port 22. Also ensure your network permits the connection.

## Supported Operating Systems

| Operating System | Versions |
|---|---|
| Ubuntu | 18.04 – 25.10 |
| Debian | 10 – 13 |

## Repository Structure

```text
setups/
├── setup.sh
└── README.md
```

## Security Considerations

This script enables root login and password-based SSH authentication.

These settings increase exposure to unauthorized access, particularly on publicly accessible servers.

For production environments, prefer:

- SSH key-based authentication
- Disabling direct root login
- Disabling password authentication
- Restricting SSH access through security groups

Never expose your root password or share it publicly.

## License

This project is licensed under the [MIT License](https://github.com/nihent/setups/blob/main/LICENSE).

---

<div align="center">


[GitHub](https://github.com/nihent) · [Repository](https://github.com/nihent/setups)

</div>
