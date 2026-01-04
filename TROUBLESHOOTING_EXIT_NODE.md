# 🔧 Exit Node Troubleshooting - IPs Still Different

If your RDP server and local machine still have different public IPs, follow these steps:

## Step 1: Verify Exit Node is Enabled on Local Machine

**On your local Windows machine, run:**

```powershell
# Check current Tailscale status
& "$env:ProgramFiles\Tailscale\tailscale.exe" status

# Look for "offers exit node" in the output
```

**If you DON'T see "offers exit node", enable it:**

```powershell
# Enable exit node advertising
& "$env:ProgramFiles\Tailscale\tailscale.exe" up --advertise-exit-node

# Verify it's now advertising
& "$env:ProgramFiles\Tailscale\tailscale.exe" status
```

## Step 2: Approve Exit Node in Tailscale Admin Console

This is **CRITICAL** - even if your machine advertises as an exit node, it won't work until approved:

1. Go to: https://login.tailscale.com/admin/machines
2. Find your local machine in the list
3. Click the **three dots (⋮)** next to it
4. Click **"Edit route settings..."**
5. Under "Exit node", toggle **"Use as exit node"** to ON
6. Click **"Save"**

**This step is often missed and is the most common reason for failure!**

## Step 3: Verify Your Local Machine's Hostname

The workflow needs to identify your machine. Check your Tailscale hostname:

```powershell
& "$env:ProgramFiles\Tailscale\tailscale.exe" status
```

Look for a line like:
```
100.x.x.x   your-machine-name    username@   windows  -
```

The `your-machine-name` is your hostname.

## Step 4: Update Workflow to Use Specific Hostname (Recommended)

Instead of auto-detection, specify your exact machine:

**Edit `.github/workflows/main.yml`** around line 102:

**Find this line:**
```yaml
# $exitNode = ($devices.Peer | Where-Object { $_.HostName -eq "your-local-machine" }).ID
```

**Uncomment and replace with YOUR hostname:**
```yaml
$exitNode = ($devices.Peer | Where-Object { $_.HostName -eq "your-actual-hostname" }).ID
```

**Then comment out the auto-detect section** (lines ~104-112):
```yaml
# Option 2: Auto-detect (use the first non-runner device)
# $currentHostname = "gh-runner-$env:GITHUB_RUN_ID"
# foreach ($peer in $devices.Peer.PSObject.Properties) {
#     ...
# }
```

## Step 5: Check Workflow Logs

After running the workflow, check the "Configure Exit Node" step output:

**What you SHOULD see:**
```
Configuring runner to use your local machine's public IP...
Found potential exit node: your-machine-name (xxxxx)
Setting exit node to: xxxxx

=== NETWORK CONFIGURATION ===
Exit Node: xxxxx
Public IP: YOUR.LOCAL.IP.HERE
This should match your local machine's public IP
============================
```

**What you might see if it's NOT working:**
```
No exit node found. Make sure your local machine is connected to Tailscale.
The runner will use its own public IP (GitHub's datacenter IP).
```

## Step 6: Verify on RDP Server

After connecting to the RDP server:

```powershell
# Check Tailscale status on the runner
& "$env:ProgramFiles\Tailscale\tailscale.exe" status

# Should show something like:
# Exit node: your-machine-name (100.x.x.x)
```

```powershell
# Check public IP
(Invoke-WebRequest -Uri "https://api.ipify.org" -UseBasicParsing).Content

# This should match your local machine's IP
```

## Common Issues and Fixes

### Issue 1: "No exit node found"

**Cause:** Local machine not advertising or not approved

**Fix:**
1. Enable on local machine: `tailscale up --advertise-exit-node`
2. Approve in admin console (Step 2 above)
3. Ensure local machine is online and connected to Tailscale

### Issue 2: Exit node found but IP still different

**Cause:** Exit node not actually being used by the runner

**Fix:**
```powershell
# On the RDP server, manually set exit node
& "$env:ProgramFiles\Tailscale\tailscale.exe" set --exit-node=<your-machine-tailscale-ip>

# Example:
& "$env:ProgramFiles\Tailscale\tailscale.exe" set --exit-node=100.64.0.1
```

### Issue 3: Auto-detect picks wrong machine

**Cause:** Multiple machines in your Tailscale network

**Fix:** Use specific hostname (Step 4 above)

### Issue 4: "Access denied" or "Not allowed"

**Cause:** Exit node not approved in admin console

**Fix:** Complete Step 2 above - this is mandatory!

### Issue 5: Firewall blocking

**Cause:** Windows Firewall blocking IP forwarding

**Fix on local machine:**
```powershell
# Allow Tailscale through firewall
New-NetFirewallRule -DisplayName "Tailscale Exit Node" -Direction Inbound -Action Allow -Program "$env:ProgramFiles\Tailscale\tailscaled.exe"
New-NetFirewallRule -DisplayName "Tailscale Exit Node" -Direction Outbound -Action Allow -Program "$env:ProgramFiles\Tailscale\tailscaled.exe"
```

## Quick Verification Script

**Run this on your LOCAL machine to verify everything is set up:**

```powershell
Write-Host "=== Exit Node Setup Verification ==="

# Check if Tailscale is running
$tsProcess = Get-Process tailscale* -ErrorAction SilentlyContinue
if ($tsProcess) {
    Write-Host "✅ Tailscale is running"
} else {
    Write-Host "❌ Tailscale is NOT running"
}

# Check status
$status = & "$env:ProgramFiles\Tailscale\tailscale.exe" status
Write-Host "`nTailscale Status:"
Write-Host $status

# Check if advertising exit node
if ($status -match "offers exit node" -or $status -match "exit node") {
    Write-Host "`n✅ Exit node is advertised"
} else {
    Write-Host "`n❌ Exit node is NOT advertised"
    Write-Host "Run: tailscale up --advertise-exit-node"
}

# Get your public IP
$publicIP = (Invoke-WebRequest -Uri "https://api.ipify.org" -UseBasicParsing).Content
Write-Host "`nYour Local Public IP: $publicIP"
Write-Host "The RDP server should show this same IP when exit node is working"

Write-Host "`n=== Next Steps ==="
Write-Host "1. Ensure exit node is approved in: https://login.tailscale.com/admin/machines"
Write-Host "2. Run the GitHub Actions workflow"
Write-Host "3. Check the 'Configure Exit Node' step logs"
Write-Host "4. Verify the Public IP matches: $publicIP"
```

## Manual Exit Node Configuration

If auto-detection isn't working, you can manually configure it:

**Get your local machine's Tailscale IP:**
```powershell
& "$env:ProgramFiles\Tailscale\tailscale.exe" ip -4
```

**Then add this step to your workflow AFTER the "Establish Tailscale Connection" step:**

```yaml
- name: Manually Set Exit Node
  run: |
    # Replace with YOUR local machine's Tailscale IP
    $exitNodeIP = "100.x.x.x"  # <-- Change this!
    
    Write-Host "Setting exit node to: $exitNodeIP"
    & "$env:ProgramFiles\Tailscale\tailscale.exe" set --exit-node=$exitNodeIP
    
    Start-Sleep -Seconds 5
    
    # Verify
    $publicIP = (Invoke-WebRequest -Uri "https://api.ipify.org" -UseBasicParsing).Content
    Write-Host "Public IP: $publicIP"
```

## Still Not Working?

If you've tried everything above and it's still not working, please provide:

1. **Output from local machine:**
   ```powershell
   & "$env:ProgramFiles\Tailscale\tailscale.exe" status
   ```

2. **Screenshot from Tailscale admin console** showing your machine's settings

3. **Workflow logs** from the "Configure Exit Node" step

4. **Both IPs:**
   - Local machine IP: `curl https://api.ipify.org`
   - RDP server IP: (from workflow logs or RDP session)

This will help diagnose the exact issue!
