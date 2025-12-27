# 🎮 RDP Client Optimization for Gaming

This guide helps you configure your RDP client for the best gaming experience.

## Windows Remote Desktop Connection

### Optimal Settings:

1. **Open Remote Desktop Connection** (`Win + R` → `mstsc`)

2. **Click "Show Options"**

3. **Display Tab:**
   - Resolution: `1280x720` or `1920x1080` (lower = better performance)
   - Colors: `Highest Quality (32 bit)`
   - ✅ Check "Display the connection bar when I use the full screen"

4. **Local Resources Tab:**
   - Remote audio: `Play on this computer`
   - ✅ Check "Record from this computer" (for voice chat)
   - Keyboard: `On this computer`
   - ✅ Check "Printers" (optional)
   - ✅ Check "Clipboard"

5. **Experience Tab:**
   - Connection speed: `LAN (10 Mbps or higher)`
   - ✅ Check "Persistent bitmap caching"
   - ✅ Check "Reconnect if connection is dropped"
   - ❌ Uncheck "Desktop background"
   - ❌ Uncheck "Font smoothing"
   - ❌ Uncheck "Desktop composition"
   - ❌ Uncheck "Show window contents while dragging"
   - ❌ Uncheck "Menu and window animation"
   - ❌ Uncheck "Themes"

6. **Advanced Tab:**
   - Server authentication: `Connect and don't warn me`

### Save Your Configuration:

Click **Save As** and save as `gaming-rdp.rdp` for quick access.

### Command Line (Advanced):

```cmd
mstsc /v:100.x.x.x /w:1920 /h:1080 /admin
```

## macOS Microsoft Remote Desktop

### Optimal Settings:

1. **Add PC** → Enter Tailscale IP

2. **Edit PC Settings:**
   - Display: `1920x1080` or `1280x720`
   - Color Quality: `Highest`
   - ✅ Enable "Start session in full screen"

3. **Devices & Audio:**
   - ✅ Enable "Play sound on this computer"
   - ✅ Enable "Play sound from remote PC"
   - ✅ Enable "Use microphone"

4. **Folders:**
   - Add folders you want to access from remote PC

5. **Performance:**
   - Network Quality: `Best`
   - ✅ Enable "Persistent bitmap cache"

## Linux (Remmina)

### Installation:

```bash
sudo apt install remmina remmina-plugin-rdp
```

### Optimal Settings:

1. **Create New Connection** → Protocol: `RDP`

2. **Basic Tab:**
   - Server: `100.x.x.x` (Tailscale IP)
   - Username: `RDP`
   - Password: `[from workflow logs]`
   - Resolution: `1920x1080` or `1280x720`
   - Color depth: `True color (32 bpp)`

3. **Advanced Tab:**
   - Quality: `Best (slowest)`
   - ✅ Enable "Share folder" (optional)
   - Network connection type: `LAN`

4. **Audio:**
   - Audio output mode: `Local`
   - ✅ Enable "Redirect microphone"

### Command Line:

```bash
remmina -c rdp://RDP@100.x.x.x -g 1920x1080 -a 32
```

## 🎯 Performance Optimization Tips

### 1. Network Optimization

**On Your Local Machine:**

```bash
# Windows: Disable WiFi power saving
powercfg /setacivescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# Windows: Set network adapter to high performance
# Control Panel → Network Adapter → Properties → Configure → Power Management
# Uncheck "Allow computer to turn off this device to save power"
```

**Use Wired Connection:**
- Ethernet > WiFi for gaming
- Reduces latency by 10-50ms

### 2. Tailscale Optimization

**Enable Direct Connections:**

```bash
# Check Tailscale status
tailscale status

# Look for "direct" connections (not "relay")
# If using relay, check firewall settings
```

**Disable Tailscale Relay (Force Direct):**

```bash
tailscale up --exit-node-allow-lan-access --accept-routes
```

### 3. RDP Client Tweaks

**Windows Registry Tweaks** (Run as Administrator):

```powershell
# Disable RDP bandwidth throttling
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' `
                   -Name "fEnableVirtualizedGraphics" -Value 1 -Force

# Enable hardware acceleration
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' `
                   -Name "fEnableRemoteFXAdvancedRemoteApp" -Value 1 -Force
```

### 4. Reduce Latency

**Ping Test:**

```bash
# Test latency to Tailscale IP
ping 100.x.x.x

# Ideal: < 50ms
# Acceptable: 50-100ms
# Poor: > 100ms
```

**Optimize Tailscale Route:**

```bash
# Use fastest exit node
tailscale up --exit-node=auto
```

### 5. Bandwidth Management

**Close Bandwidth-Heavy Apps:**
- Stop downloads/uploads
- Close streaming services
- Disable cloud sync (OneDrive, Dropbox)

**QoS Settings** (Router):
- Prioritize RDP traffic (port 3389)
- Prioritize Tailscale traffic (UDP 41641)

## 🎮 Game-Specific Settings

### Browser Games (Best Performance)

- Use **Microsoft Edge** or **Chrome** on remote PC
- Enable hardware acceleration in browser settings
- Close unnecessary tabs

### Cloud Gaming Services

**GeForce NOW:**
- Resolution: 1920x1080
- Frame rate: 60 FPS
- Bitrate: Automatic

**Xbox Cloud Gaming:**
- Use Edge browser (best compatibility)
- Enable "Clarity Boost" in settings

### Emulators

**RetroArch:**
- Video Driver: `gl` or `d3d11`
- Enable "Threaded Video"
- Disable "VSync" for lower latency

**Dolphin Emulator:**
- Graphics: Software Renderer (no GPU)
- Disable enhancements
- Use native resolution

## 📊 Performance Monitoring

### On Remote PC (During RDP Session):

**Task Manager:**
- Press `Ctrl + Shift + Esc`
- Monitor CPU, RAM, Network usage

**Resource Monitor:**
- Press `Win + R` → `resmon`
- Check network latency

### Latency Test:

```powershell
# On remote PC, test internet speed
Invoke-WebRequest -Uri "https://www.google.com" -UseBasicParsing | Select-Object -ExpandProperty StatusCode
```

## 🔧 Troubleshooting

### High Latency (> 100ms)

1. **Check Tailscale Connection:**
   ```bash
   tailscale status
   ```
   - Should show "direct" not "relay"

2. **Restart Tailscale:**
   ```bash
   tailscale down
   tailscale up
   ```

3. **Use Different Network:**
   - Switch from WiFi to Ethernet
   - Try mobile hotspot

### Choppy Graphics

1. **Lower Resolution:**
   - Change RDP resolution to 1280x720

2. **Disable Visual Effects:**
   - Already done in workflow

3. **Close Background Apps:**
   - On both local and remote PC

### Audio Issues

1. **Enable Audio Redirection:**
   - RDP Settings → Local Resources → Remote audio

2. **Check Audio Device:**
   - On remote PC: Settings → Sound
   - Set default playback device

3. **Restart Audio Service:**
   ```powershell
   Restart-Service -Name Audiosrv -Force
   ```

### Disconnections

1. **Increase Timeout:**
   ```powershell
   # On remote PC (if you have admin access)
   Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' `
                      -Name "KeepAliveTimeout" -Value 1 -Force
   ```

2. **Enable Auto-Reconnect:**
   - RDP Settings → Experience → Reconnect if dropped

## 🌟 Advanced: Custom RDP File

Create a `.rdp` file with optimal settings:

```ini
screen mode id:i:2
use multimon:i:0
desktopwidth:i:1920
desktopheight:i:1080
session bpp:i:32
winposstr:s:0,3,0,0,800,600
compression:i:1
keyboardhook:i:2
audiocapturemode:i:1
videoplaybackmode:i:1
connection type:i:7
networkautodetect:i:1
bandwidthautodetect:i:1
displayconnectionbar:i:1
enableworkspacereconnect:i:0
disable wallpaper:i:1
allow font smoothing:i:0
allow desktop composition:i:0
disable full window drag:i:1
disable menu anims:i:1
disable themes:i:0
disable cursor setting:i:0
bitmapcachepersistenable:i:1
full address:s:100.x.x.x
audiomode:i:0
redirectprinters:i:0
redirectcomports:i:0
redirectsmartcards:i:0
redirectclipboard:i:1
redirectposdevices:i:0
autoreconnection enabled:i:1
authentication level:i:0
prompt for credentials:i:0
negotiate security layer:i:1
remoteapplicationmode:i:0
alternate shell:s:
shell working directory:s:
gatewayhostname:s:
gatewayusagemethod:i:4
gatewaycredentialssource:i:4
gatewayprofileusagemethod:i:0
promptcredentialonce:i:0
gatewaybrokeringtype:i:0
use redirection server name:i:0
rdgiskdcproxy:i:0
kdcproxyname:s:
username:s:RDP
```

Save as `gaming-optimized.rdp` and double-click to connect!

---

**Happy Gaming! 🎮**
