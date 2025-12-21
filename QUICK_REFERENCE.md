# 🎯 Quick Reference: Persistent Storage

## When to Use Each Option

### 🆕 First Time User
```yaml
Restore from previous session?: no
Persistent storage backend: google-drive
```
**Result:** Fresh start, but files will be saved for next time

---

### 🔄 Continue Your Work
```yaml
Restore from previous session?: yes
Persistent storage backend: google-drive
```
**Result:** All files from last session restored automatically

---

### 🧹 Fresh Start (Keep Backups)
```yaml
Restore from previous session?: no
Persistent storage backend: google-drive
```
**Result:** Clean machine, but old files still in cloud

---

### ⚡ Quick Test (No Persistence)
```yaml
Restore from previous session?: no
Persistent storage backend: none
```
**Result:** Fresh machine, nothing saved

---

## 📋 Setup Checklist

- [ ] Install rclone on your computer
- [ ] Run `rclone config` to set up Google Drive or OneDrive
- [ ] Copy your rclone config file
- [ ] Add `RCLONE_CONFIG` secret to GitHub repository
- [ ] Run workflow with your chosen options

**Full setup guide:** [PERSISTENT_STORAGE_GUIDE.md](PERSISTENT_STORAGE_GUIDE.md)

---

## 💡 Pro Tips

1. **Automatic Backups**: Files sync every 30 minutes while RDP is active
2. **Manual Access**: Your files are always in Google Drive/OneDrive
3. **Multiple Sessions**: Use the same cloud storage for all your workflows
4. **Safety Net**: Final backup runs when you stop the workflow

---

## 🔍 What Gets Saved?

✅ Desktop files  
✅ Documents  
✅ Downloads  
✅ Any files you create in these folders

❌ Installed programs (reinstall each session)  
❌ System settings  
❌ Registry changes

---

## 🆘 Quick Troubleshooting

**Files not restoring?**
- Check if `RCLONE_CONFIG` secret is set
- Make sure you chose "yes" for restore
- Verify files exist in your Google Drive/OneDrive

**Backup failed?**
- Check workflow logs for errors
- Verify rclone config is correct
- Ensure cloud storage has enough space

---

**Need detailed help?** See [PERSISTENT_STORAGE_GUIDE.md](PERSISTENT_STORAGE_GUIDE.md)
