# 💾 Persistent Storage Setup Guide

## Overview

By default, GitHub Actions runners are **ephemeral** - every time you stop and restart the workflow, you get a fresh Windows machine with no files from your previous session.

This guide shows you how to set up **persistent storage** so your files, documents, and settings survive across sessions.

---

## 🎯 How It Works

When you run the workflow, you'll see two new options:

1. **Restore from previous session?** (`yes` / `no`)
   - `yes`: Restore your files from the last session
   - `no`: Start with a fresh, clean machine

2. **Persistent storage backend** (choose one):
   - `github-artifacts`: Store files in GitHub (simple, but limited to small files)
   - `google-drive`: Sync with Google Drive (recommended for most users)
   - `onedrive`: Sync with Microsoft OneDrive
   - `none`: No persistence (fresh start every time)

---

## 📦 Storage Options Comparison

| Feature | GitHub Artifacts | Google Drive | OneDrive |
|---------|-----------------|--------------|----------|
| **Free Storage** | 500 MB | 15 GB | 5 GB |
| **Setup Difficulty** | Easy | Medium | Medium |
| **Speed** | Fast | Medium | Medium |
| **File Size Limit** | 2 GB total | No limit | No limit |
| **Best For** | Small files | General use | Office files |

---

## 🚀 Quick Start (Recommended: Google Drive)

### Step 1: Install Rclone on Your Computer

**Windows:**
```powershell
# Using Chocolatey
choco install rclone -y

# OR download from: https://rclone.org/downloads/
```

**Mac/Linux:**
```bash
# Mac
brew install rclone

# Linux
curl https://rclone.org/install.sh | sudo bash
```

### Step 2: Configure Rclone for Google Drive

Run this command and follow the prompts:

```bash
rclone config
```

**Configuration Steps:**
1. Type `n` for "New remote"
2. Name: `gdrive`
3. Storage: Choose `drive` (Google Drive)
4. Client ID: Press Enter (leave blank)
5. Client Secret: Press Enter (leave blank)
6. Scope: Choose `1` (Full access)
7. Root folder ID: Press Enter (leave blank)
8. Service Account: Press Enter (leave blank)
9. Auto config: Type `y` (yes)
   - Your browser will open - sign in to Google
   - Click "Allow" to grant access
10. Team Drive: Type `n` (no)
11. Confirm: Type `y` (yes)
12. Quit: Type `q`

### Step 3: Get Your Rclone Config

**Windows:**
```powershell
Get-Content "$env:APPDATA\rclone\rclone.conf"
```

**Mac/Linux:**
```bash
cat ~/.config/rclone/rclone.conf
```

Copy the **entire output** (it will look like this):

```ini
[gdrive]
type = drive
scope = drive
token = {"access_token":"ya29.a0AfH6...","token_type":"Bearer",...}
```

### Step 4: Add to GitHub Secrets

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `RCLONE_CONFIG`
5. Value: Paste the entire rclone config from Step 3
6. Click **Add secret**

### Step 5: Run the Workflow

1. Go to **Actions** tab in your repository
2. Click **RDP** workflow
3. Click **Run workflow**
4. Choose your options:
   - **Restore from previous session?**: `yes` (or `no` for first run)
   - **Persistent storage backend**: `google-drive`
5. Click **Run workflow**

---

## 🔧 OneDrive Setup (Alternative)

Follow the same steps as Google Drive, but in Step 2:

```bash
rclone config
```

**Configuration:**
1. Name: `onedrive`
2. Storage: Choose `onedrive`
3. Client ID: Press Enter
4. Client Secret: Press Enter
5. Region: Choose `1` (Microsoft Cloud Global)
6. Auto config: Type `y`
7. Drive type: Choose `1` (OneDrive Personal)
8. Drive: Choose `0` (first option)
9. Confirm: Type `y`

Then continue with Steps 3-5 above.

---

## 📁 What Gets Backed Up?

The following folders are automatically synced:

- **Desktop** (`C:\Users\<username>\Desktop`)
- **Documents** (`C:\Users\<username>\Documents`)
- **Downloads** (`C:\Users\<username>\Downloads`)

### Backup Schedule:

- **Every 30 minutes** while RDP is active (automatic)
- **On shutdown** when you stop the workflow (automatic)

---

## 🎮 Usage Examples

### Example 1: First Time Setup

```yaml
Restore from previous session?: no
Persistent storage backend: google-drive
```

Result: Fresh machine, but files will be backed up for next time.

### Example 2: Continue Working

```yaml
Restore from previous session?: yes
Persistent storage backend: google-drive
```

Result: All your files from last session are restored.

### Example 3: Fresh Start (Keep Backups)

```yaml
Restore from previous session?: no
Persistent storage backend: google-drive
```

Result: Fresh machine, but your old files are still in Google Drive.

### Example 4: No Persistence

```yaml
Restore from previous session?: no
Persistent storage backend: none
```

Result: Fresh machine every time, no backups.

---

## 🔍 Troubleshooting

### "RCLONE_CONFIG secret not set"

**Solution:** Make sure you added the `RCLONE_CONFIG` secret in GitHub Settings → Secrets.

### "Rclone command not found"

**Solution:** The workflow automatically installs rclone. If it fails, check the workflow logs.

### Files not restoring

**Checklist:**
1. ✅ Is `RCLONE_CONFIG` secret set correctly?
2. ✅ Did you choose `yes` for "Restore from previous session?"
3. ✅ Did you run the workflow at least once before to create a backup?
4. ✅ Check your Google Drive/OneDrive for the `RDP-Backup` folder

### Backup taking too long

**Solution:** Large files slow down sync. Consider:
- Using `github-artifacts` for small files only
- Excluding large files from Desktop/Documents/Downloads
- Using a faster internet connection

---

## 🔐 Security Notes

### Is My Data Safe?

- **Google Drive/OneDrive**: Your files are encrypted in transit and at rest
- **GitHub Secrets**: Encrypted and only accessible during workflow runs
- **Rclone Config**: Contains OAuth tokens - keep the secret secure!

### Best Practices:

1. ✅ Use strong passwords for Google/Microsoft accounts
2. ✅ Enable 2FA on your Google/Microsoft account
3. ✅ Don't share your `RCLONE_CONFIG` secret
4. ✅ Regularly review your Google Drive/OneDrive permissions
5. ✅ Delete old backups you no longer need

---

## 📊 Storage Limits

### Google Drive (Free Tier)
- **15 GB** total (shared with Gmail and Photos)
- **Unlimited** file size (individual files)

### OneDrive (Free Tier)
- **5 GB** total
- **250 GB** max file size

### GitHub Artifacts
- **500 MB** per repository
- **2 GB** max artifact size
- Artifacts expire after 90 days

---

## 🎯 Advanced: Custom Backup Folders

Want to backup additional folders? Edit the workflow file:

```yaml
# In the "Restore Previous Session" step, add:
rclone sync "gdrive:RDP-Backup/MyFolder" "$env:USERPROFILE\MyFolder" -v

# In the "Maintain Connection" and "Backup Session on Shutdown" steps, add:
rclone sync "$env:USERPROFILE\MyFolder" "gdrive:RDP-Backup/MyFolder" -v
```

---

## 💡 Tips & Tricks

### Tip 1: Manual Backup Trigger
While connected via RDP, you can manually trigger a backup by creating a file named `BACKUP_NOW.txt` on your Desktop. The next backup cycle will sync it.

### Tip 2: Check Backup Status
Your Google Drive/OneDrive will have a folder called `RDP-Backup` with subfolders:
- `Desktop/`
- `Documents/`
- `Downloads/`

### Tip 3: Restore Specific Files
You can manually download files from Google Drive/OneDrive even without running the workflow.

### Tip 4: Multiple Machines
You can use the same `RCLONE_CONFIG` for multiple GitHub repositories - they'll all sync to the same cloud storage.

---

## 🆘 Need Help?

- **Rclone Documentation**: https://rclone.org/docs/
- **Google Drive Setup**: https://rclone.org/drive/
- **OneDrive Setup**: https://rclone.org/onedrive/
- **GitHub Actions**: https://docs.github.com/actions

---

## 📝 Summary

1. ✅ Install rclone on your computer
2. ✅ Configure rclone for Google Drive or OneDrive
3. ✅ Add `RCLONE_CONFIG` to GitHub Secrets
4. ✅ Run workflow with "Restore from previous session: yes"
5. ✅ Your files are now persistent across sessions!

**Made with ❤️ for seamless remote work**

🔒 Secure | 💾 Persistent | ☁️ Cloud-Synced | 🚀 Automatic
