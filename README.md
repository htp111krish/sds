# GitHub Past Date Commit Tools

A collection of PowerShell scripts to create Git commits with custom past dates and automatically push them to GitHub. Perfect for building up your contribution graph with historical commits.

## 📦 What's Included

| File | Description |
|------|-------------|
| `make_commit.ps1` | **Manual** - Create single commits with custom dates |
| `auto_commit_watcher.ps1` | **Automated** - Watch for changes and auto-commit with date ranges |
| `start_watcher.ps1` | **Helper** - Interactive setup for the auto watcher |
| `HOW_TO_USE_IN_NEW_PROJECT.md` | Quick start guide for any project |
| `AUTO_COMMIT_GUIDE.md` | Complete documentation for auto watcher |

---

## 🚀 Quick Start

### Option 1: Manual Commits (Precise Control)

```powershell
# Make changes to your files, then:
.\make_commit.ps1 -Date "2025-07-15" -Message "Added new feature"
```

**Best for:**
- Single specific commits
- Precise date/time control
- One-off backdated commits

---

### Option 2: Auto Watcher (Automated)

```powershell
# Start the watcher
.\auto_commit_watcher.ps1 -StartDate "2025-07-01" -EndDate "2025-12-31"

# Now just code and save files - commits happen automatically!
```

**Best for:**
- Building commit history over time
- Automated workflow
- Multiple commits across date ranges

---

## 📖 Documentation

- **New to this?** → Read `HOW_TO_USE_IN_NEW_PROJECT.md`
- **Want automation?** → Read `AUTO_COMMIT_GUIDE.md`
- **Quick setup?** → Run `.\start_watcher.ps1`

---

## 💡 Example Use Cases

### Use Case 1: Single Important Commit
```powershell
# You built a feature on a specific date
.\make_commit.ps1 -Date "2025-08-15" -Message "Implemented user authentication"
```

### Use Case 2: Build 6-Month History
```powershell
# Start watcher for July-December 2025
.\auto_commit_watcher.ps1 -StartDate "2025-07-01" -EndDate "2025-12-31" -CommitsPerDay 8

# Work on your project normally, every save = auto commit
```

### Use Case 3: Fill Gaps in Contribution Graph
```powershell
# Fill in a specific month with moderate activity
.\auto_commit_watcher.ps1 -StartDate "2025-09-01" -EndDate "2025-09-30" -CommitsPerDay 5
```

---

## ⚙️ Features

### Manual Script (`make_commit.ps1`)
- ✅ Custom date for each commit
- ✅ Custom commit messages
- ✅ Validates date format
- ✅ Checks for changes before committing
- ✅ Simple and straightforward

### Auto Watcher (`auto_commit_watcher.ps1`)
- ✅ Watches directory for file changes
- ✅ Auto-commits and pushes to GitHub
- ✅ Progresses through date ranges
- ✅ Configurable commits per day
- ✅ Spreads commits throughout each day
- ✅ Saves progress (resumable)
- ✅ Colorful status output

---

## 🎯 Comparison

| Feature | Manual Script | Auto Watcher |
|---------|--------------|--------------|
| **Automation** | Run after each change | Run once, watches continuously |
| **Date Range** | One date at a time | Entire range automatically |
| **Commits** | One per run | Multiple, auto-progresses |
| **Control** | Full control | Set it and forget it |
| **Workflow** | Save → Run → Repeat | Run → Just save files |

---

## 📋 Requirements

- Windows with PowerShell
- Git installed and configured
- GitHub repository with push access
- PowerShell execution policy allowing scripts

### Enable Scripts (if needed)
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 🔧 Setup for New Projects

1. **Copy scripts** to your project folder
2. **Initialize Git** (if not already):
   ```powershell
   git init
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
   ```
3. **Choose your workflow**:
   - Manual: Use `make_commit.ps1`
   - Automated: Use `auto_commit_watcher.ps1`

---

## 📊 How Auto Watcher Works

```
You start the script with a date range
         ↓
Script watches for file changes
         ↓
You edit and save files
         ↓
Script auto-commits with current date
         ↓
After X commits → moves to next date
         ↓
Repeats until date range complete
```

---

## 🎨 Example Workflow

### Scenario: Building a Portfolio Website

```powershell
# Terminal 1: Start auto watcher for 3 months
.\auto_commit_watcher.ps1 -StartDate "2025-07-01" -EndDate "2025-09-30" -CommitsPerDay 6

# Your work:
# Week 1: Build HTML structure → Save files → Auto commits to July dates
# Week 2: Add CSS styling → Save files → Auto commits continue
# Week 3: Add JavaScript → Save files → Progresses through August
# Week 4: Polish and refine → Save files → Completes September
```

Result: **~540 commits** spread across 3 months! 🎉

---

## ⚠️ Important Notes

### Before Using:
1. Ensure Git is configured:
   ```powershell
   git config user.name "Your Name"
   git config user.email "your.email@example.com"
   ```

2. Ensure remote is set:
   ```powershell
   git remote -v
   ```

3. Test with a small date range first!

### Best Practices:
- ✅ Make real code changes (not dummy commits)
- ✅ Use meaningful commit messages
- ✅ Vary commits per day for natural patterns
- ✅ Keep the watcher terminal open
- ❌ Don't abuse - use responsibly
- ❌ Don't close terminal while watcher is running

---

## 🛠️ Troubleshooting

### Script won't run?
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Push fails?
- Check internet connection
- Verify GitHub credentials
- Ensure push permissions

### No commits happening?
- Make sure files are actually changing
- Check you're in correct directory
- Verify you saved the files

### Want to reset?
```powershell
Remove-Item .commit_state.json
```

---

## 📚 Full Documentation

- **Quick Start**: `HOW_TO_USE_IN_NEW_PROJECT.md`
- **Auto Watcher Guide**: `AUTO_COMMIT_GUIDE.md`
- **This File**: Overview and comparison

---

## 🎯 Which Tool Should I Use?

### Use Manual Script (`make_commit.ps1`) if:
- You want precise control over each commit
- You're making occasional backdated commits
- You prefer manual workflow
- You need specific commit times

### Use Auto Watcher (`auto_commit_watcher.ps1`) if:
- You want to build commit history automatically
- You're working on a project over time
- You want hands-off automation
- You need to fill date ranges

### Use Both if:
- Important commits → Manual script
- Regular development → Auto watcher
- Maximum flexibility!

---

## 🚀 Get Started Now!

### For Manual Commits:
```powershell
.\make_commit.ps1 -Date "2025-07-01" -Message "Initial commit"
```

### For Automated Commits:
```powershell
.\start_watcher.ps1
# Follow the interactive prompts
```

### For Advanced Users:
```powershell
.\auto_commit_watcher.ps1 -StartDate "2025-07-01" -EndDate "2025-12-31" -CommitsPerDay 8 -CheckIntervalSeconds 3
```

---

## 📞 Need Help?

1. Read `HOW_TO_USE_IN_NEW_PROJECT.md` for basics
2. Read `AUTO_COMMIT_GUIDE.md` for auto watcher details
3. Check troubleshooting sections above

---

## ⭐ Tips for Best Results

1. **Spread out your work** - Don't make all commits at once
2. **Vary commit counts** - Some days 5, some days 15
3. **Make real changes** - Better than dummy commits
4. **Use meaningful messages** - Describe what you actually did
5. **Test first** - Try with a small date range
6. **Keep it natural** - Mimic real development patterns

---

Happy coding! 🎉
