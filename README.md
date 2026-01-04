# 🎮 Windows RDP Server via Tailscale

A GitHub Actions-powered Windows RDP server accessible via Tailscale VPN.

## 🚀 Features

- ✅ **Secure RDP Access** via Tailscale VPN
- ✅ **Auto-generated Credentials** with strong passwords
- ✅ **One-Line Connection Command** for instant access
- ✅ **60-hour runtime** (GitHub Actions maximum)
- ✅ **No manual configuration** required


## ⚙️ Setup

### Prerequisites

1. **GitHub Repository Secrets** - Add these to your repository:
   - `TAILSCALE_AUTH_KEY` - Get from [Tailscale Admin Console](https://login.tailscale.com/admin/settings/keys)

### Installation

1. **Fork or clone this repository**
2. **Add your Tailscale auth key** to GitHub Secrets
3. **Trigger the workflow** manually from Actions tab
4. **Wait 2-3 minutes** for setup to complete
5. **Copy the one-line command** from workflow logs and paste it in your terminal


## 🎯 Usage

### Starting the Server

1. Go to **Actions** tab in your GitHub repository
2. Click on **RDP** workflow
3. Click **Run workflow** → **Run workflow**
4. Wait for the "Maintain Connection" step to show your connection command

### Connecting to RDP

**The workflow will display a one-line command like this:**
```
cmdkey /generic:100.x.x.x /user:RDP /pass:YourPassword && mstsc /v:100.x.x.x
```

**To connect:**
1. **Copy the command** from the workflow logs
2. **Open PowerShell or CMD** on your Windows machine
3. **Paste and run** the command
4. **RDP will automatically connect** without asking for credentials!

**Alternative Methods:**

**On Windows (Manual):**
1. Open **Remote Desktop Connection** (`mstsc.exe`)
2. Enter the Tailscale IP address
3. Click **Connect**
4. Enter username `RDP` and the password from logs

**On macOS:**
1. Download **Microsoft Remote Desktop** from App Store
2. Add PC with the Tailscale IP
3. Connect with username `RDP` and password

**On Linux:**
```bash
remmina -c rdp://RDP@100.x.x.x
```
## 🔧 Use Cases

This RDP server can be used for:
- ✅ **Remote Windows Access** - Access a Windows environment from anywhere
- ✅ **Testing & Development** - Test Windows applications
- ✅ **Browser-based tasks** - Access Windows-only websites or services
- ✅ **Temporary Windows VM** - Quick Windows environment without local setup
- ✅ **Automation** - Run Windows scripts or tools remotely

## 🔧 Customization

### Install Additional Software

Add a new step in `main.yml` after the Tailscale connection:

```yaml
- name: Install Software
  run: |
    # Install via Chocolatey
    choco install googlechrome -y --no-progress
    choco install vscode -y --no-progress
    
    # Or download and install directly
    $url = "https://example.com/installer.exe"
    $installer = "$env:TEMP\installer.exe"
    Invoke-WebRequest -Uri $url -OutFile $installer
    Start-Process $installer -ArgumentList "/S" -Wait
```

## 🛡️ Security

- **Tailscale VPN** - Only accessible via your private Tailscale network
- **Strong Passwords** - Auto-generated 16-character passwords with special characters
- **Firewall Rules** - RDP only accessible through Tailscale
- **No Public Exposure** - Server is not accessible from the internet

## 📊 Resource Specifications

| Resource | Specification |
|----------|--------------|
| **CPU** | 2-core Intel Xeon |
| **RAM** | 7 GB |
| **Storage** | 14 GB SSD |
| **GPU** | Basic Display Adapter (Software Rendering) |
| **Network** | 1 Gbps |
| **OS** | Windows Server 2022 |

## ⏱️ Runtime Management

### Current Behavior:
- Workflow runs for **maximum 60 hours** (GitHub Actions limit)
- Automatically terminates after timeout
- Must be manually restarted

### To Stop Manually:
1. Go to **Actions** tab
2. Click on the running workflow
3. Click **Cancel workflow**

### To Extend Runtime:
- **Option 1**: Manually restart the workflow every 60 hours
- **Option 2**: Use scheduled triggers (see Advanced Configuration)
- **Option 3**: Use self-hosted runners (unlimited runtime)

## 🚨 Troubleshooting

### Can't Connect to RDP
1. **Check Tailscale** - Ensure you're connected to Tailscale on your local machine
2. **Verify IP** - Check the Tailscale IP in workflow logs
3. **Firewall** - Ensure port 3389 is not blocked on your local machine

### Poor Gaming Performance
1. **Reduce Resolution** - Lower RDP display resolution to 1280x720
2. **Disable Visual Effects** - Already done in the workflow
3. **Close Background Apps** - Free up RAM on the runner
4. **Use Wired Connection** - Reduce network latency on your end

### Audio Not Working
1. **Enable Audio Redirection** in RDP client settings
2. **Check Audio Settings** on the remote Windows machine
3. **Restart RDP Session** after changing audio settings

### Workflow Fails
1. **Check Tailscale Auth Key** - Ensure it's valid and not expired
2. **Check Logs** - Review the failed step in workflow logs
3. **Retry** - Sometimes GitHub Actions has temporary issues

## 🌟 Advanced Configuration

### Auto-Restart Before Timeout

Add to the `on:` section in `main.yml`:

```yaml
on:
  workflow_dispatch:
  schedule:
    - cron: '0 */50 * * *'  # Runs every 50 hours
```

### Custom Hostname

Modify the Tailscale connection step:

```yaml
& "$env:ProgramFiles\Tailscale\tailscale.exe" up --authkey=${{ secrets.TAILSCALE_AUTH_KEY }} --hostname=my-gaming-pc
```

### Static Password (Not Recommended)

Replace the password generation with:

```yaml
$password = "${{ secrets.RDP_PASSWORD }}"
```

Then add `RDP_PASSWORD` to GitHub Secrets.

## 📝 License

MIT License - Feel free to use and modify!

## 🤝 Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## ⚠️ Disclaimer

This setup is intended for personal use and testing. GitHub Actions is not designed for production gaming servers. Use responsibly and within GitHub's Terms of Service.

---

**Made with ❤️ for remote gaming enthusiasts**
