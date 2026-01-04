# 🔑 Setting Up Persistent Tailscale Authentication

## Problem
Every time you run the workflow, Tailscale creates a new device that needs authentication.

## Solution
Use a **reusable, non-expiring auth key** instead of the default ephemeral key.

## Steps to Create a Reusable Auth Key

### 1. Go to Tailscale Admin Console
https://login.tailscale.com/admin/settings/keys

### 2. Click "Generate auth key..."

### 3. Configure the Auth Key Settings

**Important settings:**

✅ **Reusable** - Check this box
- Allows the key to be used multiple times
- Each workflow run can use the same key

✅ **Ephemeral** - UNCHECK this box (or check based on preference)
- **Unchecked (Recommended)**: Devices persist even after workflow ends
  - Pro: You can reconnect to the same device
  - Con: Old devices accumulate in your Tailscale admin
  
- **Checked**: Devices auto-delete when workflow ends
  - Pro: Automatic cleanup
  - Con: New device every time

⏰ **Expiration** - Set to "No expiration" or a long duration
- Recommended: 90 days or longer
- Or select "Never expires" if available

🏷️ **Tags** (Optional)
- Add tag like `tag:github-actions`
- Helps organize your devices

### 4. Copy the Auth Key

After clicking "Generate key", copy the key that looks like:
```
tskey-auth-xxxxxxxxxxxxx-yyyyyyyyyyyyyyyyyyyyyyyy
```

### 5. Update GitHub Secret

1. Go to your GitHub repository: https://github.com/work-abhijit/Windows-RDP
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Find `TAILSCALE_AUTH_KEY`
4. Click **Update** (or delete and recreate)
5. Paste your new reusable auth key
6. Click **Update secret**

## Current vs New Behavior

### Current (Ephemeral Key):
```
Run 1: Creates device "gh-runner-123" → Disconnects → Device deleted
Run 2: Creates device "gh-runner-456" → Disconnects → Device deleted
Run 3: Creates device "gh-runner-789" → Disconnects → Device deleted
```

### With Reusable Key (Ephemeral OFF):
```
Run 1: Creates device "gh-runner-123" → Disconnects → Device stays
Run 2: Creates device "gh-runner-456" → Disconnects → Device stays
Run 3: Creates device "gh-runner-789" → Disconnects → Device stays
```
*Note: Old devices stay in your network but offline*

### With Reusable Key (Ephemeral ON):
```
Run 1: Creates device "gh-runner-123" → Disconnects → Device auto-deleted
Run 2: Creates device "gh-runner-456" → Disconnects → Device auto-deleted
Run 3: Creates device "gh-runner-789" → Disconnects → Device auto-deleted
```
*Note: Automatic cleanup, but still creates new device each time*

## Recommended Configuration

**For your use case (gaming/RDP), I recommend:**

✅ **Reusable**: ON
❌ **Ephemeral**: OFF
⏰ **Expiration**: 90 days or Never
🏷️ **Tags**: `tag:github-rdp` (optional)

**Why?**
- You can reconnect to the same device if needed
- Auth key works indefinitely
- Manual cleanup of old devices (once a month)

## Alternative: Auto-Cleanup Old Devices

If you want automatic cleanup but persistent auth, you can add a cleanup step to your workflow:

```yaml
- name: Cleanup Old Tailscale Devices
  run: |
    # This would require Tailscale API access
    # For now, manually delete old devices from:
    # https://login.tailscale.com/admin/machines
```

## Verify Your Current Key Type

Check your current auth key settings:

1. Go to: https://login.tailscale.com/admin/settings/keys
2. Look at your existing keys
3. Check if "Reusable" is enabled
4. Check expiration date

If your current key is:
- ❌ Not reusable → Generate new one
- ❌ Expiring soon → Generate new one
- ✅ Reusable + Long expiration → You're good!

## Manual Device Cleanup (Optional)

To clean up old offline devices:

1. Go to: https://login.tailscale.com/admin/machines
2. Filter by "Offline" devices
3. Look for old `gh-runner-*` devices
4. Click three dots (⋮) → **Delete device**

**Tip:** Do this cleanup once a month or when you have too many old devices.

## Summary

**What you need to do:**
1. ✅ Generate a new **reusable** auth key (no expiration)
2. ✅ Update `TAILSCALE_AUTH_KEY` in GitHub Secrets
3. ✅ Run workflow - no more re-authentication needed!

**Result:**
- Same auth key works for all workflow runs
- No need to regenerate or update
- Works until key expires (or never if set to no expiration)

---

**After updating the key, you'll never need to update it again (until it expires)!** 🎉
