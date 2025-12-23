# 🎉 New Feature: Persistent Storage

## What Changed?

Your Windows RDP server now supports **persistent storage** across sessions! No more losing your files when you restart the workflow.

---

## ✨ Key Features Added

### 1. **Session Restore Options**
When you run the workflow, you now see two new choices:

**Restore from previous session?**
- `yes` - Restore all your files from the last session
- `no` - Start with a fresh, clean machine

**Persistent storage backend:**
- `google-drive` - Sync with Google Drive (15 GB free)
- `onedrive` - Sync with Microsoft OneDrive (5 GB free)
- `github-artifacts` - Store in GitHub (500 MB, basic)
- `none` - No persistence (old behavior)

### 2. **Automatic Backups**
- **Every 30 minutes**: Your files are automatically synced to the cloud
- **On shutdown**: Final backup when you stop the workflow
- **No manual work**: Everything happens automatically!

### 3. **What Gets Saved**
The following folders are automatically backed up:
- Desktop (`C:\Users\<username>\Desktop`)
- Documents (`C:\Users\<username>\Documents`)
- Downloads (`C:\Users\<username>\Downloads`)

---

## 📁 New Files Added

1. **PERSISTENT_STORAGE_GUIDE.md** - Complete setup guide with step-by-step instructions
2. **QUICK_REFERENCE.md** - Quick reference card for common scenarios
3. **Updated README.md** - Added persistent storage feature to main README
4. **Updated .github/workflows/main.yml** - Enhanced workflow with backup/restore logic

---

## 🚀 How to Use

### Quick Start (5 minutes):

1. **Install rclone** on your computer:
   ```bash
   # Windows
   choco install rclone -y
   
   # Mac
   brew install rclone
   ```

2. **Configure Google Drive**:
   ```bash
   rclone config
   # Choose: n (new), name: gdrive, type: drive
   # Follow the prompts and sign in to Google
   ```

3. **Get your config**:
   ```bash
   # Windows
   Get-Content "$env:APPDATA\rclone\rclone.conf"
   
   # Mac/Linux
   cat ~/.config/rclone/rclone.conf
   ```

4. **Add to GitHub Secrets**:
   - Go to Settings → Secrets → New secret
   - Name: `RCLONE_CONFIG`
   - Value: Paste the entire config

5. **Run the workflow**:
   - Choose "Restore: yes" (or "no" for first time)
   - Choose "Storage: google-drive"
   - Done! Your files will be saved automatically

---

## 💡 Usage Examples

### Example 1: First Time Setup
```
Restore from previous session?: no
Storage backend: google-drive
```
**Result:** Fresh machine, files will be backed up for next time

### Example 2: Continue Working
```
Restore from previous session?: yes
Storage backend: google-drive
```
**Result:** All your files from last session are restored!

### Example 3: Quick Test (No Persistence)
```
Restore from previous session?: no
Storage backend: none
```
**Result:** Fresh machine, nothing saved (old behavior)

---

## 🔧 Technical Details

### Workflow Changes:

1. **New Input Parameters** (lines 4-23):
   - `restore_session`: Choice between yes/no
   - `storage_backend`: Choice of cloud provider

2. **Restore Session Step** (lines 71-155):
   - Downloads files from cloud storage
   - Restores Desktop, Documents, Downloads
   - Installs and configures rclone automatically

3. **Periodic Backup** (lines 351-389):
   - Runs every 30 minutes during active session
   - Syncs changes to cloud storage
   - Shows progress in workflow logs

4. **Final Backup on Shutdown** (lines 391-437):
   - Runs when workflow is stopped
   - Ensures all changes are saved
   - Uses `if: always()` to run even on cancellation

### Cloud Storage Integration:

- **Rclone**: Industry-standard cloud sync tool
- **Encryption**: All transfers are encrypted
- **Bidirectional Sync**: Upload and download support
- **Multiple Providers**: Google Drive, OneDrive, and more

---

## 🔐 Security

- ✅ **Encrypted transfers**: All data encrypted in transit
- ✅ **Secure storage**: GitHub Secrets are encrypted at rest
- ✅ **OAuth tokens**: No passwords stored, only OAuth tokens
- ✅ **Private cloud**: Your files stay in your Google/Microsoft account

---

## 📊 Storage Comparison

| Provider | Free Storage | Speed | Best For |
|----------|-------------|-------|----------|
| **Google Drive** | 15 GB | Fast | General use (recommended) |
| **OneDrive** | 5 GB | Fast | Office files, Microsoft users |
| **GitHub Artifacts** | 500 MB | Very Fast | Small files, simple setup |

---

## 🎯 Benefits

1. **No More Data Loss**: Your work is always saved
2. **Seamless Experience**: Feels like a persistent machine
3. **Multiple Sessions**: Use the same storage across different workflows
4. **Automatic**: No manual backup needed
5. **Flexible**: Choose when to restore or start fresh

---

## 🆘 Troubleshooting

### Files not restoring?
- Check if `RCLONE_CONFIG` secret is set
- Verify you chose "yes" for restore
- Check your Google Drive for `RDP-Backup` folder

### Backup failed?
- Check workflow logs for errors
- Verify rclone config is correct
- Ensure cloud storage has enough space

### Need help?
- See [PERSISTENT_STORAGE_GUIDE.md](PERSISTENT_STORAGE_GUIDE.md) for detailed troubleshooting
- Check [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for common scenarios

---

## 📖 Documentation

- **Full Setup Guide**: [PERSISTENT_STORAGE_GUIDE.md](PERSISTENT_STORAGE_GUIDE.md)
- **Quick Reference**: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
- **Main README**: [README.md](README.md)

---

## 🎊 Summary

You asked for a way to **continue using the same machine** instead of getting a fresh one each time. Now you have it!

**Before:** 
- Stop workflow → All files lost ❌
- Restart → Fresh machine, start over 😞

**After:**
- Stop workflow → Files backed up to cloud ✅
- Restart with "Restore: yes" → All files restored! 🎉

**Made with ❤️ for seamless productivity**

🔒 Secure | 💾 Persistent | ☁️ Cloud-Synced | 🚀 Automatic
