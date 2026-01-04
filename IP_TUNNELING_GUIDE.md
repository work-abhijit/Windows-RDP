# 🌐 IP Tunneling Setup Guide

This guide explains how to configure your Windows RDP server to use **your local machine's public IP address** by routing all traffic through a Tailscale exit node.

## 🎯 Use Cases

- **Geo-restricted content**: Access services that are only available in your region
- **IP whitelisting**: Use services that whitelist your home/office IP
- **Consistent IP**: Maintain the same public IP across sessions
- **Privacy**: Route traffic through your own network instead of GitHub's datacenter

## 📋 Prerequisites

1. **Tailscale installed** on your local machine
2. **Tailscale auth key** added to GitHub Secrets
3. **Admin access** on your local machine (to enable exit node)

## 🚀 Setup Instructions

### Step 1: Enable Exit Node on Your Local Machine

#### On Windows:

1. **Open PowerShell as Administrator**

2. **Enable exit node advertising:**
   ```powershell
   & "$env:ProgramFiles\Tailscale\tailscale.exe" up --advertise-exit-node
   ```

3. **Verify it's advertising:**
   ```powershell
   & "$env:ProgramFiles\Tailscale\tailscale.exe" status
   ```
   You should see your machine listed with exit node capability.

#### On macOS:

1. **Open Terminal**

2. **Enable exit node:**
   ```bash
   sudo tailscale up --advertise-exit-node
   ```

3. **Verify:**
   ```bash
   tailscale status
   ```

#### On Linux:

1. **Enable IP forwarding:**
   ```bash
   echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
   echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
   sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
   ```

2. **Enable exit node:**
   ```bash
   sudo tailscale up --advertise-exit-node
   ```

3. **Verify:**
   ```bash
   tailscale status
   ```

### Step 2: Approve Exit Node in Tailscale Admin Console

1. **Go to**: [Tailscale Admin Console](https://login.tailscale.com/admin/machines)

2. **Find your local machine** in the list

3. **Click the three dots (⋮)** next to your machine

4. **Click "Edit route settings..."**

5. **Enable "Use as exit node"**

6. **Click "Save"**

### Step 3: Configure Workflow (Optional - Auto-detect)

The workflow will **automatically detect** your local machine as an exit node. However, for more reliability, you can specify your machine's hostname:

1. **Find your Tailscale hostname:**
   ```powershell
   # Windows
   & "$env:ProgramFiles\Tailscale\tailscale.exe" status
   
   # macOS/Linux
   tailscale status
   ```
   Look for your machine's name (e.g., `my-laptop`, `home-pc`)

2. **Edit `.github/workflows/main.yml`:**
   
   Find this line (around line 102):
   ```yaml
   # $exitNode = ($devices.Peer | Where-Object { $_.HostName -eq "your-local-machine" }).ID
   ```
   
   Uncomment and replace with your hostname:
   ```yaml
   $exitNode = ($devices.Peer | Where-Object { $_.HostName -eq "my-laptop" }).ID
   ```

3. **Comment out the auto-detect section** (lines 104-112) if you want to use only your specific machine.

### Step 4: Test the Setup

1. **Trigger the GitHub Actions workflow**

2. **Check the workflow logs** for the "Configure Exit Node" step

3. **Verify the output shows:**
   ```
   === NETWORK CONFIGURATION ===
   Exit Node: <your-machine-id>
   Public IP: <your-local-public-ip>
   This should match your local machine's public IP
   ============================
   ```

4. **Confirm the IP matches** by checking your local public IP:
   ```powershell
   # Windows
   (Invoke-WebRequest -Uri "https://api.ipify.org" -UseBasicParsing).Content
   
   # macOS/Linux
   curl https://api.ipify.org
   ```

## 🔍 Verification

### On the RDP Server (After Connecting):

1. **Open PowerShell** on the RDP session

2. **Check public IP:**
   ```powershell
   (Invoke-WebRequest -Uri "https://api.ipify.org" -UseBasicParsing).Content
   ```

3. **Check detailed IP info:**
   ```powershell
   Invoke-RestMethod -Uri "https://ipapi.co/json/"
   ```
   This should show your local ISP and location.

### Test Geo-Location:

Visit these sites from the RDP session:
- [WhatIsMyIP.com](https://www.whatismyip.com/)
- [IPLocation.net](https://www.iplocation.net/)
- [IPInfo.io](https://ipinfo.io/)

They should all show **your local machine's IP and location**.

## 🛠️ Troubleshooting

### Exit Node Not Found

**Symptoms:**
```
No exit node found. Make sure your local machine is connected to Tailscale.
```

**Solutions:**

1. **Check Tailscale is running** on your local machine:
   ```powershell
   # Windows
   Get-Process tailscale*
   
   # macOS/Linux
   ps aux | grep tailscale
   ```

2. **Verify exit node is advertised:**
   ```powershell
   tailscale status
   ```
   Should show "offers exit node" or similar.

3. **Re-enable exit node:**
   ```powershell
   tailscale up --advertise-exit-node --reset
   ```

4. **Check Tailscale admin console** - ensure exit node is approved.

### Exit Node Set But IP Doesn't Match

**Symptoms:**
- Exit node shows as configured
- But public IP is still GitHub's datacenter IP

**Solutions:**

1. **Verify exit node is actually being used:**
   ```powershell
   # On the RDP server
   & "$env:ProgramFiles\Tailscale\tailscale.exe" status
   ```
   Should show "Exit node: <your-machine>"

2. **Check routing:**
   ```powershell
   # On the RDP server
   tracert 8.8.8.8
   ```
   First hop should be your Tailscale exit node IP.

3. **Restart Tailscale on runner:**
   - Cancel and re-run the workflow

4. **Check firewall** on your local machine:
   - Ensure it's not blocking forwarded traffic
   - Windows: Allow Tailscale through Windows Firewall

### Local Machine Goes Offline

**Symptoms:**
- Exit node was working, then stopped
- RDP server loses internet connection

**Solutions:**

1. **Keep your local machine online** while using the RDP server

2. **Use a dedicated exit node** (like a Raspberry Pi or always-on PC)

3. **Set up fallback** - the workflow will warn but continue without exit node

### Performance Issues

**Symptoms:**
- Slow internet on RDP server
- High latency

**Solutions:**

1. **Check your local upload speed:**
   - All RDP server traffic goes through your local upload
   - Recommended: 50+ Mbps upload

2. **Use wired connection** on your local machine:
   - Ethernet > WiFi for exit node

3. **Reduce concurrent usage:**
   - Don't download/upload heavily on local machine while using RDP

4. **Consider a VPS exit node:**
   - Use a cloud VPS with high bandwidth as exit node instead

## 🔒 Security Considerations

### Firewall Rules

Your local machine will forward all traffic from the RDP server. Ensure:

1. **Firewall is enabled** on your local machine
2. **Only Tailscale traffic** is forwarded (automatic with Tailscale)
3. **No port forwarding** rules that could expose your network

### Network Isolation

The RDP server can access:
- ✅ Internet through your IP
- ✅ Other Tailscale devices (if allowed)
- ❌ Your local network (unless `--exit-node-allow-lan-access` is set)

### Bandwidth Usage

Monitor your local machine's bandwidth:
- All RDP server traffic counts against your ISP limits
- Streaming, downloads, etc. on RDP = your bandwidth

## 📊 Advanced Configuration

### Multiple Exit Nodes

If you have multiple machines, specify priority:

```yaml
# In workflow, set preferred exit node
$preferredNodes = @("home-pc", "office-laptop", "raspberry-pi")
foreach ($preferred in $preferredNodes) {
    $exitNode = ($devices.Peer | Where-Object { $_.HostName -eq $preferred -and $_.Online }).ID
    if ($exitNode) { break }
}
```

### Fallback to Direct Connection

If exit node is unavailable, use GitHub's IP:

```yaml
if (-not $exitNode) {
    Write-Host "Using direct connection (GitHub datacenter IP)"
    # Continue without exit node
}
```

### Custom DNS

Route DNS through your local network:

```powershell
# On local machine (exit node)
tailscale up --advertise-exit-node --accept-dns=true
```

### Split Tunneling

Route only specific traffic through exit node:

```powershell
# On RDP server - route only specific IPs through exit node
# This requires custom routing rules (advanced)
```

## 🌟 Use Case Examples

### 1. Access Indian Geo-Restricted Content

**Setup:**
- Local machine in India with exit node enabled
- RDP server routes through Indian IP
- Access Hotstar, SonyLIV, etc. from RDP

### 2. IP Whitelisting for Work

**Setup:**
- Office PC as exit node
- RDP server uses office IP
- Access work resources that whitelist office IP

### 3. Consistent IP for Services

**Setup:**
- Home PC as exit node
- RDP server always uses home IP
- Avoid IP-based rate limiting or blocks

## 📝 Quick Reference Commands

### Local Machine (Exit Node):

```powershell
# Enable exit node
tailscale up --advertise-exit-node

# Disable exit node
tailscale up --advertise-exit-node=false

# Check status
tailscale status

# Get your public IP
curl https://api.ipify.org
```

### RDP Server (After Connection):

```powershell
# Check current exit node
& "$env:ProgramFiles\Tailscale\tailscale.exe" status

# Check public IP
(Invoke-WebRequest -Uri "https://api.ipify.org" -UseBasicParsing).Content

# Test routing
tracert 8.8.8.8
```

## ❓ FAQ

**Q: Will this slow down my RDP connection?**
A: The RDP connection itself uses Tailscale's direct peer-to-peer connection. Only internet traffic from the RDP server is routed through your local machine.

**Q: Can I use a VPS as an exit node?**
A: Yes! Install Tailscale on a VPS and enable exit node. This gives you a dedicated IP without keeping your local machine online.

**Q: Does this work with IPv6?**
A: Yes, Tailscale supports IPv6 exit nodes. Ensure IPv6 forwarding is enabled on your exit node.

**Q: Can multiple runners use the same exit node?**
A: Yes, your local machine can serve as an exit node for multiple Tailscale devices simultaneously.

**Q: What if my local IP is dynamic?**
A: That's fine! The exit node routes traffic through whatever your current public IP is. The RDP server will always use your current IP.

---

**Need help?** Check the [Tailscale Exit Nodes Documentation](https://tailscale.com/kb/1103/exit-nodes/)
