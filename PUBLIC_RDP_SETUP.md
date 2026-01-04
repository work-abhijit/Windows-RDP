# 🌍 Public RDP Access Setup

This guide shows you how to set up **public RDP access** so anyone with the username and password can connect, **without needing Tailscale**.

## ⚠️ Security Warning

**Public RDP is less secure than Tailscale VPN!** Only use this if:
- You need to share access with people who can't use Tailscale
- You use a strong password
- You understand the security risks

---

## 🚀 Setup Instructions

### Step 1: Get ngrok Auth Token (Free)

1. Go to [ngrok.com](https://ngrok.com/) and sign up (free)
2. Go to [Your Authtoken](https://dashboard.ngrok.com/get-started/your-authtoken)
3. Copy your authtoken

### Step 2: Add Secrets to GitHub

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add these secrets:

| Secret Name | Value | Required? |
|-------------|-------|-----------|
| `NGROK_AUTH_TOKEN` | Your ngrok authtoken | ✅ Yes |
| `RDP_USERNAME` | Your desired username (e.g., "Admin") | ⚠️ Optional (defaults to "RDP") |
| `RDP_PASSWORD` | Your desired password | ⚠️ Optional (defaults to "RDP@2026!Secure") |

### Step 3: Run the Workflow

1. Go to **Actions** tab
2. Select **Public RDP (Anyone Can Connect)**
3. Click **Run workflow** → **Run workflow**
4. Wait 2-3 minutes

### Step 4: Get Connection Details

The workflow will display:
```
🌍 ANYONE CAN CONNECT WITH THESE DETAILS:

  Address:  0.tcp.ngrok.io
  Port:     12345
  Username: RDP
  Password: RDP@2026!Secure
```

### Step 5: Connect from Anywhere

**Anyone** can now connect using:

**PowerShell:**
```powershell
cmdkey /generic:0.tcp.ngrok.io:12345 /user:RDP /pass:RDP@2026!Secure; mstsc /v:0.tcp.ngrok.io:12345
```

**CMD:**
```cmd
cmdkey /generic:0.tcp.ngrok.io:12345 /user:RDP /pass:RDP@2026!Secure & mstsc /v:0.tcp.ngrok.io:12345
```

**Manual Connection:**
1. Open Remote Desktop Connection (`mstsc.exe`)
2. Enter: `0.tcp.ngrok.io:12345`
3. Username: `RDP`
4. Password: `RDP@2026!Secure`

---

## 🔒 Security Best Practices

### 1. Use Strong Password
Set a strong password in GitHub Secrets:
```
RDP_PASSWORD = MyStr0ng!P@ssw0rd#2026
```

### 2. Change Credentials Regularly
Update the password in GitHub Secrets periodically

### 3. Monitor Access
Check the workflow logs to see when connections are made

### 4. Use Tailscale for Sensitive Work
For sensitive operations, use the original Tailscale workflow instead

---

## 📊 Comparison: Public RDP vs Tailscale

| Feature | Public RDP (ngrok) | Tailscale VPN |
|---------|-------------------|---------------|
| **Setup** | Medium (need ngrok account) | Medium (need Tailscale account) |
| **Security** | ⚠️ Lower (exposed to internet) | ✅ High (private VPN) |
| **Access** | ✅ Anyone with credentials | ❌ Only Tailscale network members |
| **Speed** | Good | Better (direct connection) |
| **Firewall** | ✅ Works behind any firewall | ✅ Works behind any firewall |
| **Cost** | Free (ngrok free tier) | Free (Tailscale free tier) |

---

## 🆚 Which Should You Use?

### Use **Public RDP** if:
- ✅ You need to share access with multiple people
- ✅ Users can't install Tailscale
- ✅ You need quick, temporary access
- ✅ You're okay with internet exposure

### Use **Tailscale** if:
- ✅ You want maximum security
- ✅ Only you need access
- ✅ You can install Tailscale on your devices
- ✅ You're handling sensitive data

---

## 🛠️ Troubleshooting

### ngrok tunnel not starting
- Check that `NGROK_AUTH_TOKEN` is set correctly
- Free ngrok accounts have limits (1 tunnel at a time)

### Can't connect to RDP
- Make sure you're using the correct host:port from logs
- Check that username and password are correct
- Try without saving credentials first

### Connection drops
- ngrok free tier has 2-hour session limits
- Restart the workflow to get a new tunnel

---

## 📝 Notes

- **ngrok free tier** limits: 1 tunnel, 40 connections/min
- **Tunnel URL changes** every time you restart the workflow
- **No persistent storage** - files are lost when workflow ends
- **60-hour maximum** runtime (GitHub Actions limit)

---

**Ready to try it? Run the "Public RDP (Anyone Can Connect)" workflow!** 🚀
