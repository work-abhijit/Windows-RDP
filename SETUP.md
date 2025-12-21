# 🚀 CLI Setup Guide

Complete setup using command line only.

---

## 📋 Prerequisites

- GitHub account
- Git installed
- PowerShell (Windows) or Terminal (Mac/Linux)

---

## ⚡ Quick Setup (5 Minutes)

### Step 1: Add GitHub Secrets

```bash
# Go to your repository settings
https://github.com/work-abhijit/Windows-Server/settings/secrets/actions

# Add these 3 secrets (click "New repository secret" for each):
# 1. RDP_USERNAME = your_username
# 2. RDP_PASSWORD = YourStrongP@ssw0rd123
# 3. TAILSCALE_AUTH_KEY = tskey-auth-xxxxx
```

**Get Tailscale Auth Key:**
```bash
# 1. Sign up at https://tailscale.com/
# 2. Go to https://login.tailscale.com/admin/settings/keys
# 3. Click "Generate auth key"
# 4. Check "Reusable" and copy the key
```

---

### Step 2: Install Tailscale on Your Computer

**Windows:**
```powershell
# Download and install
winget install tailscale.tailscale

# Or download from: https://tailscale.com/download/windows
```

**Mac:**
```bash
brew install tailscale
```

**Linux:**
```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

---

### Step 3: Run the Workflow

**Option A: Via GitHub Web UI**
```bash
# 1. Go to: https://github.com/work-abhijit/Windows-Server/actions
# 2. Click "RDP" workflow
# 3. Click "Run workflow" → "Run workflow"
```

**Option B: Via GitHub CLI**
```bash
# Install GitHub CLI first
winget install GitHub.cli  # Windows
# or
brew install gh  # Mac

# Login
gh auth login

# Run workflow
gh workflow run RDP -R work-abhijit/Windows-Server
```

---

### Step 4: Get Connection Info

**Via GitHub Web UI:**
```bash
# 1. Go to Actions → Click running workflow
# 2. Click "Maintain Connection" step
# 3. Note the Tailscale IP and credentials
```

**Via GitHub CLI:**
```bash
# Watch workflow logs
gh run watch

# Or view logs
gh run view --log
```

---

### Step 5: Connect via RDP

**Windows:**
```powershell
# Open Remote Desktop
mstsc

# Enter:
# Computer: [Tailscale IP from logs]
# Username: [Your RDP_USERNAME]
# Password: [Your RDP_PASSWORD]
```

**Mac:**
```bash
# Install Microsoft Remote Desktop from App Store
# Then connect using Tailscale IP and credentials
```

**Linux:**
```bash
# Install Remmina
sudo apt install remmina

# Connect
remmina -c rdp://username@tailscale-ip
```

---

## 🔒 Security Features

### Automatic IP Detection
- Workflow detects your public IP when you trigger it
- Firewall allows RDP only from:
  - ✅ Your detected IP
  - ✅ Tailscale network (100.64.0.0/10)
  - ❌ All other IPs blocked

### Static Credentials
- Same username/password every time
- No random passwords
- Stored securely in GitHub Secrets

---

## 🛠️ CLI Commands Reference

### Check Workflow Status
```bash
# List recent runs
gh run list -w RDP

# View specific run
gh run view [RUN_ID]

# Watch live logs
gh run watch
```

### Cancel Running Workflow
```bash
# List running workflows
gh run list --status in_progress

# Cancel specific run
gh run cancel [RUN_ID]

# Or via web: https://github.com/work-abhijit/Windows-Server/actions
```

### Update GitHub Secrets
```bash
# Update RDP username
gh secret set RDP_USERNAME -b "new_username"

# Update RDP password
gh secret set RDP_PASSWORD -b "NewP@ssw0rd123"

# Update Tailscale key
gh secret set TAILSCALE_AUTH_KEY -b "tskey-auth-xxxxx"
```

### Check Tailscale Status
```bash
# Check if Tailscale is running
tailscale status

# Get your Tailscale IP
tailscale ip -4

# Login to Tailscale
tailscale up
```

---

## 🔧 Troubleshooting

### Workflow Fails to Start
```bash
# Check workflow syntax
gh workflow view RDP

# View error logs
gh run view --log
```

### Cannot Connect to RDP
```bash
# 1. Verify Tailscale is running
tailscale status

# 2. Check your Tailscale IP
tailscale ip -4

# 3. Test connection
Test-NetConnection -ComputerName [TAILSCALE_IP] -Port 3389
```

### Secrets Not Set
```bash
# List all secrets
gh secret list

# Set missing secrets
gh secret set RDP_USERNAME
gh secret set RDP_PASSWORD
gh secret set TAILSCALE_AUTH_KEY
```

### IP Detection Failed
```bash
# Check your public IP
curl https://api.ipify.org
# or
curl https://ifconfig.me/ip

# Re-run the workflow - it will detect again
gh workflow run RDP
```

---

## 📊 Quick Reference

### Essential URLs
```
Repository: https://github.com/work-abhijit/Windows-Server
Actions: https://github.com/work-abhijit/Windows-Server/actions
Secrets: https://github.com/work-abhijit/Windows-Server/settings/secrets/actions
Tailscale Admin: https://login.tailscale.com/admin
Tailscale Keys: https://login.tailscale.com/admin/settings/keys
```

### Required Secrets
```
RDP_USERNAME      = Your RDP username
RDP_PASSWORD      = Your RDP password (min 12 chars, strong)
TAILSCALE_AUTH_KEY = tskey-auth-xxxxxxxxxxxxx
```

### Connection Info
```
Address: [Check workflow logs for Tailscale IP]
Username: [Your RDP_USERNAME]
Password: [Your RDP_PASSWORD]
```

---

## ⚡ One-Line Setup (Advanced)

If you have GitHub CLI and Tailscale already set up:

```bash
# Set secrets and run workflow in one go
gh secret set RDP_USERNAME -b "admin" && \
gh secret set RDP_PASSWORD -b "YourP@ssw0rd123" && \
gh secret set TAILSCALE_AUTH_KEY -b "tskey-auth-xxxxx" && \
gh workflow run RDP && \
gh run watch
```

---

## 🎯 What Happens When You Run

1. **IP Detection** - Detects your public IP automatically
2. **RDP Setup** - Enables Remote Desktop with your credentials
3. **Firewall Config** - Blocks all IPs except yours + Tailscale
4. **Tailscale Install** - Installs and connects to Tailscale VPN
5. **Connection Ready** - Shows Tailscale IP and credentials
6. **Stays Active** - Runs for up to 60 hours (or until cancelled)

---

## 💡 Tips

- **Use Tailscale** for best security (recommended)
- **Check logs** for Tailscale IP and connection info
- **Cancel workflow** when done to save GitHub Actions minutes
- **Re-run anytime** - IP detection works automatically each time
- **Strong password** - Use min 12 chars with mixed case, numbers, symbols

---

## ❓ Common Questions

**Q: Where is the server located?**  
A: GitHub Actions servers (US/Europe). Not in India.

**Q: Can I access geo-restricted Indian websites?**  
A: No, server has US/Europe IP. Use Oracle Cloud (Mumbai) for that.

**Q: How long does it run?**  
A: Up to 60 hours (3600 minutes) or until you cancel it.

**Q: Does it cost money?**  
A: No, completely free (GitHub Actions + Tailscale free tiers).

**Q: Can others connect?**  
A: No, firewall blocks all IPs except yours + Tailscale network.

---

**Setup complete! Run the workflow and connect via RDP.** 🎉
