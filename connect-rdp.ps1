# One-Click RDP Connection Script
# This script connects to your GitHub Actions RDP server

# Configuration
$RDP_IP = "100.96.144.102"  # Update this from workflow logs
$RDP_USER = "RDP"
$RDP_PASS = "YOUR_PASSWORD_HERE"  # Update this from workflow logs

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Connecting to GitHub Actions RDP Server" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Server: $RDP_IP" -ForegroundColor Yellow
Write-Host "Username: $RDP_USER" -ForegroundColor Yellow
Write-Host ""

# Save credentials to Windows Credential Manager
Write-Host "Saving credentials..." -ForegroundColor Green
cmdkey /generic:$RDP_IP /user:$RDP_USER /pass:$RDP_PASS | Out-Null

# Launch RDP
Write-Host "Launching Remote Desktop..." -ForegroundColor Green
mstsc /v:$RDP_IP

Write-Host ""
Write-Host "Connection initiated!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
