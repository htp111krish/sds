# Quick Start Script for Auto Commit Watcher
# This provides an easy interactive way to start the watcher

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AUTO COMMIT WATCHER - QUICK START" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Get start date
Write-Host "Enter the START date (YYYY-MM-DD format):" -ForegroundColor Yellow
Write-Host "Example: 2025-07-01" -ForegroundColor Gray
$startDate = Read-Host "Start Date"

# Get end date
Write-Host "`nEnter the END date (YYYY-MM-DD format):" -ForegroundColor Yellow
Write-Host "Example: 2025-12-31" -ForegroundColor Gray
$endDate = Read-Host "End Date"

# Get commits per day
Write-Host "`nHow many commits per day? (default: 10)" -ForegroundColor Yellow
Write-Host "Recommended: 5-15 for natural looking activity" -ForegroundColor Gray
$commitsInput = Read-Host "Commits per day (press Enter for 10)"
$commitsPerDay = if ($commitsInput) { [int]$commitsInput } else { 10 }

# Confirm settings
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "  CONFIGURATION SUMMARY" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Start Date:       $startDate" -ForegroundColor White
Write-Host "End Date:         $endDate" -ForegroundColor White
Write-Host "Commits per day:  $commitsPerDay" -ForegroundColor White
Write-Host "========================================`n" -ForegroundColor Green

Write-Host "Ready to start? (Y/N)" -ForegroundColor Yellow
$confirm = Read-Host

if ($confirm -eq 'Y' -or $confirm -eq 'y') {
    Write-Host "`nStarting Auto Commit Watcher...`n" -ForegroundColor Green
    
    # Run the watcher script
    & "$PSScriptRoot\auto_commit_watcher.ps1" -StartDate $startDate -EndDate $endDate -CommitsPerDay $commitsPerDay
} else {
    Write-Host "`nCancelled. No changes made." -ForegroundColor Yellow
}
