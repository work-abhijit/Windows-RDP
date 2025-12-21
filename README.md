# 🖥️ Secure Windows RDP Server via GitHub Actions

A secure, automated Windows RDP server deployment using GitHub Actions, Tailscale VPN, and advanced firewall protection.

---

## 🎯 Features

✅ **Static Credentials** - Use the same username/password every time  
✅ **Auto IP Detection** - Automatically restricts access to the machine that triggers the workflow  
✅ **Firewall Protected** - Only accessible via Tailscale VPN + your IP  
✅ **Persistent Storage** - Keep your files across sessions with Google Drive/OneDrive sync  
✅ **Free VPN** - Tailscale free tier (100 devices, 3 users)  
✅ **Fast & Secure** - Peer-to-peer encryption, no speed impact  
✅ **Global Access** - Connect from India or anywhere in the world  
✅ **Zero Configuration** - No manual IP setup required  

---

## 🚀 Quick Start

```bash
# 1. Add GitHub Secrets (RDP_USERNAME, RDP_PASSWORD, TAILSCALE_AUTH_KEY)
# 2. Install Tailscale on your computer
# 3. (Optional) Set up persistent storage with RCLONE_CONFIG secret
# 4. Run workflow from GitHub Actions
# 5. Connect via RDP using Tailscale IP
```

📖 **Complete CLI setup guide**: See [SETUP.md](SETUP.md)  
💾 **Persistent storage guide**: See [PERSISTENT_STORAGE_GUIDE.md](PERSISTENT_STORAGE_GUIDE.md)

---

## 💾 Persistent Storage

**Problem:** GitHub Actions runners are ephemeral - every restart gives you a fresh machine with no files.

**Solution:** Automatic cloud sync with Google Drive or OneDrive!

### How It Works:

1. **Choose your storage** when running the workflow (Google Drive, OneDrive, or none)
2. **Restore files** from your last session automatically
3. **Auto-backup** every 30 minutes while working
4. **Final backup** when you stop the workflow

### What Gets Saved:
- ✅ Desktop files
- ✅ Documents
- ✅ Downloads
- ✅ Any files you create

**Quick setup:** See [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for a 5-minute setup guide.

---



## 🔐 Security Architecture

### Firewall Rules:
- ❌ **Blocks**: All public internet RDP connections (default deny)
- ✅ **Allows**: Tailscale network (100.64.0.0/10)
- ✅ **Allows**: Auto-detected IP of triggering machine
- 🔒 **Result**: Only YOU can connect, everyone else is blocked

### VPN Protection:
- **Tailscale**: End-to-end encrypted peer-to-peer VPN
- **No public exposure**: Server not accessible from internet
- **Zero-trust network**: Only authorized devices can connect

### Authentication:
- **Static credentials**: Stored securely in GitHub Secrets
- **Strong password**: Enforced through configuration
- **Admin access**: Full Windows administrator privileges

---

## 🌐 VPN Information

### Tailscale (Recommended - Already Integrated)
- **Free Tier**: 100 devices, 3 users, unlimited data
- **Speed**: No throttling (peer-to-peer)
- **Security**: End-to-end encryption
- **Access**: From anywhere including India

### Alternative Free VPNs (For Other Purposes)
- **ProtonVPN**: Unlimited data, free servers in US/NL/JP
- **Windscale**: 10GB/month, India servers on paid plan
- **TunnelBear**: 500MB/month, India servers available

**Note**: Tailscale is the best choice for this RDP setup.

---

## 📖 Full Documentation

See [SETUP.md](SETUP.md) for complete CLI-based setup instructions, troubleshooting, and command reference.

---

## 🛠️ Troubleshooting

### Cannot connect to RDP
1. Verify Tailscale is running on your computer
2. Check you're using the correct Tailscale IP from logs
3. Ensure workflow is still running

### Wrong username or password
1. Double-check GitHub Secrets (no extra spaces)
2. Re-run workflow after updating secrets

### Workflow fails
1. Verify all required secrets are set
2. Check Tailscale auth key is valid
3. Review workflow logs for specific errors

📖 **More help**: See [SETUP_GUIDE.md](SETUP_GUIDE.md) → Troubleshooting

---

## 📊 System Requirements

### GitHub Actions Runner:
- **OS**: Windows Server (latest)
- **Runtime**: Up to 72 hours maximum
- **Resources**: Standard GitHub Actions runner

### Your Computer:
- **OS**: Windows, Mac, Linux, Android, or iOS
- **Software**: Tailscale client + RDP client
- **Network**: Internet connection

---

## 🔄 How to Stop

1. Go to GitHub Actions
2. Find the running workflow
3. Click `Cancel workflow`

The server will shut down immediately.

---

## 📝 License

This project is open source and available for personal and educational use.

---

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

---

## ⚠️ Disclaimer

This setup is designed for personal use and testing. For production environments, consider:
- Using a dedicated VPS or cloud server
- Implementing additional security measures
- Regular security audits
- Backup and disaster recovery plans

---

## 📞 Support

- **Documentation**: See files in this repository
- **Tailscale Help**: [tailscale.com/kb](https://tailscale.com/kb)
- **GitHub Actions**: [docs.github.com/actions](https://docs.github.com/actions)

---

**Made with ❤️ for secure remote access**

🔒 Secure | 🚀 Fast | 🌐 Global | 💰 Free
