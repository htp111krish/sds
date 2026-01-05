# Auto Commit Watcher - Complete Guide

## 🎯 What This Script Does

The `auto_commit_watcher.ps1` script automatically watches your project directory for file changes and commits them to GitHub with **custom past dates**. It's perfect for building up your GitHub contribution graph with historical commits.

### Key Features:
- ✅ Monitors directory for file changes automatically
- ✅ Commits and pushes changes with custom past dates
- ✅ Moves to next date after specified number of commits
- ✅ Spreads commits throughout the day (different times)
- ✅ Saves progress (can resume if interrupted)
- ✅ Works continuously in the background

---

## 🚀 Quick Start

### Basic Usage

```powershell
# Example: Commit to dates from July 2025 to December 2025
.\auto_commit_watcher.ps1 -StartDate "2025-07-01" -EndDate "2025-12-31"
```

This will:
- Watch for file changes in your project
- Make 10 commits per day (default)
- Automatically push to GitHub
- Move to next date after 10 commits

---

## 📋 All Parameters

### Required Parameters:

| Parameter | Description | Example |
|-----------|-------------|---------|
| `-StartDate` | First date in range (YYYY-MM-DD) | `"2025-07-01"` |
| `-EndDate` | Last date in range (YYYY-MM-DD) | `"2025-12-31"` |

### Optional Parameters:

| Parameter | Description | Default | Example |
|-----------|-------------|---------|---------|
| `-CommitsPerDay` | Number of commits per date | `10` | `-CommitsPerDay 5` |
| `-Message` | Base commit message | `"Update project content"` | `-Message "Feature update"` |
| `-CheckIntervalSeconds` | How often to check for changes | `5` | `-CheckIntervalSeconds 10` |

---

## 💡 Usage Examples

### Example 1: Default Settings (10 commits/day)
```powershell
.\auto_commit_watcher.ps1 -StartDate "2025-07-01" -EndDate "2025-12-31"
```

### Example 2: Custom Commits Per Day
```powershell
# Make 5 commits per day
.\auto_commit_watcher.ps1 -StartDate "2025-07-01" -EndDate "2025-12-31" -CommitsPerDay 5
```

### Example 3: Custom Message
```powershell
.\auto_commit_watcher.ps1 -StartDate "2025-07-01" -EndDate "2025-12-31" -Message "Daily progress"
```

### Example 4: Slower Check Interval (saves CPU)
```powershell
# Check for changes every 10 seconds instead of 5
.\auto_commit_watcher.ps1 -StartDate "2025-07-01" -EndDate "2025-12-31" -CheckIntervalSeconds 10
```

### Example 5: All Custom Parameters
```powershell
.\auto_commit_watcher.ps1 `
    -StartDate "2025-07-01" `
    -EndDate "2025-12-31" `
    -CommitsPerDay 8 `
    -Message "Project development" `
    -CheckIntervalSeconds 3
```

---

## 🔄 How It Works

### Step-by-Step Process:

1. **Start the Script**: Run with your desired date range
2. **Script Watches**: Continuously monitors your directory for changes
3. **You Edit Files**: Make changes to any files in your project
4. **Auto Commit**: When you save, script automatically:
   - Stages all changes (`git add .`)
   - Commits with the current date in the range
   - Pushes to GitHub
5. **Progress Tracking**: After 10 commits (or your custom number), moves to next date
6. **Repeat**: Continues until all dates in range are complete

### Time Distribution:
Commits are spread throughout each day:
- Commit 1/10: ~00:00
- Commit 2/10: ~02:24
- Commit 3/10: ~04:48
- ... and so on
- Commit 10/10: ~21:36

---

## 📊 What You'll See

### When Script Starts:
```
========================================
  AUTO COMMIT WATCHER STARTED
========================================
Date Range: 2025-07-01 to 2025-12-31
Commits per day: 10
Check interval: 5 seconds
Current Date: 2025-07-01
Commits today: 0/10

Watching for file changes... (Press Ctrl+C to stop)
========================================
```

### When You Save a File:
```
[14:32:15] Changes detected! Staging files...
[14:32:15] Committing with date: 2025-07-01 00:00:00
[14:32:15] Pushing to GitHub...
[14:32:16] ✓ SUCCESS! Commit 1/10 pushed for 2025-07-01
```

### When Moving to Next Date:
```
========================================
  MOVING TO NEXT DATE
========================================
New Date: 2025-07-02
Commits today: 0/10
========================================
```

---

## 🎮 Workflow

### Typical Usage Pattern:

1. **Start the Script in One Terminal**:
   ```powershell
   cd "d:\New folder\INTERVIEW\Github\green"
   .\auto_commit_watcher.ps1 -StartDate "2025-07-01" -EndDate "2025-12-31"
   ```

2. **Work on Your Project in Another Window**:
   - Edit your code files
   - Save changes
   - Script automatically commits and pushes

3. **Let It Run**:
   - Keep the terminal open
   - Every save = 1 commit
   - After 10 saves = next date

4. **Stop When Done**:
   - Press `Ctrl+C` to stop
   - Progress is saved automatically
   - Can resume later

---

## 💾 State Management

### Progress Saving:
- Script creates `.commit_state.json` to track progress
- If interrupted, run again with same parameters to resume
- Automatically cleans up when complete

### Resume Example:
```powershell
# Start script
.\auto_commit_watcher.ps1 -StartDate "2025-07-01" -EndDate "2025-12-31"

# ... make 5 commits on 2025-07-01 ...
# ... press Ctrl+C to stop ...

# Resume later (continues from commit 6/10 on 2025-07-01)
.\auto_commit_watcher.ps1 -StartDate "2025-07-01" -EndDate "2025-12-31"
```

---

## ⚠️ Important Notes

### Before Running:

1. **Ensure Git is Configured**:
   ```powershell
   git config user.name "Your Name"
   git config user.email "your.email@example.com"
   ```

2. **Ensure Remote is Set**:
   ```powershell
   git remote -v  # Should show your GitHub repo
   ```

3. **Ensure You're Authenticated**:
   - Script will push to GitHub automatically
   - Make sure you have push permissions
   - Use SSH or credential manager

### During Running:

- ✅ **DO**: Make real code changes and save files
- ✅ **DO**: Keep terminal window open
- ❌ **DON'T**: Close the terminal (unless you want to pause)
- ❌ **DON'T**: Make manual git commits (let script handle it)

### After Completion:

- Script automatically exits when date range is complete
- `.commit_state.json` is automatically deleted
- All commits are on GitHub with your custom dates

---

## 🛠️ Troubleshooting

### Script Won't Start:
```powershell
# Enable script execution (run as Administrator)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Push Fails:
- Check internet connection
- Verify GitHub credentials
- Ensure you have push permissions

### No Commits Happening:
- Make sure you're saving files
- Check that files are actually changing
- Verify you're in the correct directory

### Want to Reset:
```powershell
# Delete state file to start fresh
Remove-Item .commit_state.json
```

---

## 🎯 Pro Tips

### 1. **Spread Out Your Work**:
   - Don't make all 10 commits at once
   - Space them out over time for more realistic pattern

### 2. **Vary Commit Counts**:
   - Some days use `-CommitsPerDay 5`
   - Other days use `-CommitsPerDay 15`
   - Makes contribution graph look more natural

### 3. **Use Meaningful Changes**:
   - Make real code improvements
   - Add features, fix bugs, update docs
   - Better than dummy commits

### 4. **Multiple Projects**:
   - Run script in different project folders
   - Use different date ranges
   - Build comprehensive contribution history

---

## 📈 Example Scenarios

### Scenario 1: Build 6-Month History
```powershell
# July to December 2025, moderate activity
.\auto_commit_watcher.ps1 -StartDate "2025-07-01" -EndDate "2025-12-31" -CommitsPerDay 7
```

### Scenario 2: Intense Development Period
```powershell
# One month, high activity
.\auto_commit_watcher.ps1 -StartDate "2025-11-01" -EndDate "2025-11-30" -CommitsPerDay 15
```

### Scenario 3: Casual Contributions
```powershell
# Whole year, light activity
.\auto_commit_watcher.ps1 -StartDate "2025-01-01" -EndDate "2025-12-31" -CommitsPerDay 3
```

---

## 🔍 Comparison with Manual Script

| Feature | `make_commit.ps1` (Manual) | `auto_commit_watcher.ps1` (Auto) |
|---------|---------------------------|----------------------------------|
| **Automation** | Manual - run each time | Automatic - watches for changes |
| **Date Range** | Single date per run | Entire date range |
| **Commits** | One commit per run | Multiple commits, auto-progresses |
| **Workflow** | Save → Run script → Repeat | Run once → Just save files |
| **Best For** | Single specific commits | Bulk historical commits |

---

## ✅ Checklist

Before running the auto watcher:

- [ ] Git is configured (name, email)
- [ ] Remote repository is set
- [ ] GitHub authentication works
- [ ] You're in the correct project directory
- [ ] You have files to work on
- [ ] You know your desired date range

---

## 🎉 You're Ready!

Start the watcher and begin coding. Every save will automatically create a commit with your custom dates!

```powershell
.\auto_commit_watcher.ps1 -StartDate "2025-07-01" -EndDate "2025-12-31"
```

Happy coding! 🚀
