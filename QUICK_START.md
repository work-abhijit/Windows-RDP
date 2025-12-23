# 🚀 Quick Start - RDP Server Fixed!

**Status:** ✅ **FIXED AND READY TO USE**

I've created **3 workflows** to help you get RDP working:

---

## 🎯 Which Workflow Should I Use?

### 1. **RDP-Simple** ⭐ RECOMMENDED FOR YOU
- **Purpose:** Simple, reliable RDP access
- **Best for:** Quick access, troubleshooting
- **Features:** Core RDP + Tailscale only
- **Setup time:** 2-3 minutes

### 2. **RDP-Diagnostic** 🔍
- **Purpose:** Test if everything is configured correctly
- **Best for:** Finding out what's wrong
- **Run this FIRST** if you're having issues

### 3. **RDP** (Original)
- **Purpose:** Full-featured with persistent storage
- **Best for:** Production use after testing
- **Features:** Everything + cloud backups

---

## ⚡ Quick Start (3 Steps)

### Step 1: Set Up Secrets

Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions**

Add these secrets:

| Secret Name | Value | Required? |
|-------------|-------|-----------|
| `TAILSCALE_AUTH_KEY` | Get from https://login.tailscale.com/admin/settings/keys | ✅ YES |
| `RDP_USERNAME` | Your username (e.g., `rdpuser`) | ⚠️ Optional* |
| `RDP_PASSWORD` | Your password (e.g., `MyPass123!`) | ⚠️ Optional* |

*If not set, defaults will be used: `rdpuser` / `P@ssw0rd123!`

---

### Step 2: Run the Workflow

1. Go to **Actions** tab in your GitHub repository
2. Click on **"RDP-Simple"** in the left sidebar
3. Click **"Run workflow"** button (top right)
4. Click the green **"Run workflow"** button
5. Wait 2-3 minutes

---

### Step 3: Connect

1. **Wait** for the workflow to show "🟢 RDP Server is running..."
2. **Find** the Tailscale IP in the logs (looks like `100.64.x.x`)
3. **Open** Remote Desktop Connection on your computer
4. **Enter** the Tailscale IP
5. **Login** with your username and password

---

## 🔍 Troubleshooting

### "I don't have a Tailscale auth key"

1. Go to https://login.tailscale.com/admin/settings/keys
2. Click **"Generate auth key"**
3. Check these boxes:
   - ✅ **Reusable**
   - ✅ **Ephemeral** (optional)
4. Set expiration to **90 days**
5. Click **"Generate key"**
6. Copy the key and add it to GitHub Secrets

---

### "The workflow failed"

1. Run the **RDP-Diagnostic** workflow first
2. Check which step failed
3. Read the error message
4. Common fixes:
   - **Missing TAILSCALE_AUTH_KEY**: Add it to secrets
   - **Invalid auth key**: Generate a new one
   - **Expired auth key**: Generate a new one

---

### "I can't connect to RDP"

**Checklist:**
- ✅ Is Tailscale running on your local computer?
- ✅ Is the workflow still running? (must be in "Keep Alive" step)
- ✅ Are you using the Tailscale IP (not public IP)?
- ✅ Are you using the correct username/password?

---

## 📋 What Changed?

### Fixed Issues:
1. ✅ **Simplified workflow** - Removed complex features that could fail
2. ✅ **Better error messages** - Clear feedback on what's wrong
3. ✅ **Diagnostic workflow** - Test everything before running RDP
4. ✅ **Default credentials** - Works even without RDP_USERNAME/PASSWORD secrets
5. ✅ **Improved Tailscale connection** - More retries, better detection

### New Files:
- `.github/workflows/rdp-simple.yml` - Simplified RDP workflow
- `.github/workflows/rdp-diagnostic.yml` - Diagnostic workflow
- `QUICK_START.md` - This file

---

## 🎯 Recommended Flow

**First Time Setup:**
```
1. Run RDP-Diagnostic → Verify everything works
2. Run RDP-Simple → Get RDP access
3. Test connection → Make sure you can connect
4. (Optional) Run RDP (main) → Use full features
```

**Regular Use:**
```
1. Run RDP-Simple
2. Connect via RDP
3. Do your work
4. Cancel workflow when done
```

---

## 💡 Pro Tips

1. **Keep the workflow running** - Don't cancel it while using RDP
2. **Bookmark the Tailscale admin** - https://login.tailscale.com/admin/machines
3. **Save your work regularly** - Workflow times out after 6 hours
4. **Use strong passwords** - If setting custom RDP_PASSWORD
5. **Check GitHub Actions usage** - Free tier has limits

---

## 🆘 Still Not Working?

1. **Run RDP-Diagnostic** - This will tell you exactly what's wrong
2. **Check the logs** - Actions tab → Click on the workflow → Expand steps
3. **Verify secrets** - Settings → Secrets → Make sure they're set
4. **Try defaults** - Remove RDP_USERNAME and RDP_PASSWORD to use defaults

---

## 📞 Next Steps

1. ✅ Add `TAILSCALE_AUTH_KEY` to GitHub Secrets
2. ✅ (Optional) Add `RDP_USERNAME` and `RDP_PASSWORD`
3. ✅ Run **RDP-Simple** workflow
4. ✅ Connect via Remote Desktop
5. ✅ Enjoy your RDP server!

---

**Ready to start?** Go to the **Actions** tab and run **RDP-Simple**! 🚀
