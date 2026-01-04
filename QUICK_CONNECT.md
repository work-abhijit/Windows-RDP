# 🚀 Quick Connect Guide

## One-Line RDP Connection

After running the GitHub Actions workflow, you'll see a command like this in the logs:

```powershell
cmdkey /generic:100.x.x.x /user:RDP /pass:YourPassword && mstsc /v:100.x.x.x
```

### How to Use:

1. **Run the GitHub Actions workflow** (Actions tab → RDP → Run workflow)
2. **Wait for "Maintain Connection" step** to complete
3. **Copy the one-line command** from the workflow logs
4. **Open PowerShell or CMD** on your Windows machine
5. **Paste and press Enter**
6. **RDP will automatically connect!**

### What This Command Does:

- `cmdkey /generic:100.x.x.x /user:RDP /pass:YourPassword` - Saves your RDP credentials
- `&&` - Runs the next command after the first succeeds
- `mstsc /v:100.x.x.x` - Opens Remote Desktop Connection to the server

### Alternative: Create a Reusable Script

If you want to save the command for repeated use, create a file called `connect.ps1`:

```powershell
# Replace these with your actual values from the workflow
$IP = "100.x.x.x"
$USER = "RDP"
$PASS = "YourPasswordHere"

# Save credentials and connect
cmdkey /generic:$IP /user:$USER /pass:$PASS
mstsc /v:$IP
```

Then just run:
```powershell
.\connect.ps1
```

### For CMD Users:

If you're using CMD instead of PowerShell, use `&` instead of `&&`:

```cmd
cmdkey /generic:100.x.x.x /user:RDP /pass:YourPassword & mstsc /v:100.x.x.x
```

### Troubleshooting:

**If the command doesn't work:**
1. Make sure you're connected to Tailscale on your local machine
2. Verify the IP address is correct (check workflow logs)
3. Try running the two commands separately:
   ```powershell
   cmdkey /generic:100.x.x.x /user:RDP /pass:YourPassword
   mstsc /v:100.x.x.x
   ```

**To remove saved credentials:**
```powershell
cmdkey /delete:100.x.x.x
```

---

**That's it! Enjoy your instant RDP connection! 🎉**
