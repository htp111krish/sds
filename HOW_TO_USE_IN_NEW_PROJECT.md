# How to Use on a New Project

You can use the `make_commit.ps1` script in **ANY** project folder to date your commits in the past.      

## Step 1: Initialize Your New Project
1. Create your new folder (e.g., `d:\MyNewWebSite`).
2. Open that folder in VS Code.
3. Open the terminal and initialize git:
   ```powershell
   git init
   ```

## Step 2: Copy the Script
Copy the `make_commit.ps1` file from this folder (`d:\New folder\INTERVIEW\Github\green`) and paste it into your new project folder (`d:\MyNewWebSite`).

## Step 3: Work & Backdate
Instead of using the normal "Commit" button in VS Code, follow this loop:

1.  **Write Code**: Create your HTML, CSS, JS files as you normally would.
2.  **Save Files**: Make sure everything is saved.
3.  **Run the Script**: Decide what date this work "happened" on.
    ```powershell
    .\make_commit.ps1 -Date "2023-06-01" -Message "Created landing page"
    ```
4.  **Repeat**: Write more features (e.g., a contact form), then run the script again with a later date (e.g., `2023-06-05`).

## Step 4: Push to GitHub
1.  Go to GitHub.com and create a **New Repository**.
2.  Copy the commands to "push an existing repository".
3.  Run them in your terminal:
    ```powershell
    git remote add origin https://github.com/YOUR_NAME/YOUR_NEW_PROJECT.git
    git push -u origin master
    ```

**Note:** You can delete the script locally or add it to `.gitignore` before the final push if you don't want the script itself to be part of the project history, though it doesn't hurt to keep it.

---

## 🚀 NEW: Automated Commit Watcher

For a more automated workflow, use the **Auto Commit Watcher** instead!

### What's the Difference?

| Feature | `make_commit.ps1` (Manual) | `auto_commit_watcher.ps1` (Auto) |
|---------|---------------------------|----------------------------------|
| **How it works** | Run script after each save | Run once, then just save files |
| **Date handling** | One date per run | Entire date range automatically |
| **Best for** | Single specific commits | Building commit history over time |

### Quick Start with Auto Watcher

1. **Copy the auto watcher files** to your new project:
   - `auto_commit_watcher.ps1`
   - `start_watcher.ps1` (optional, for easy setup)

2. **Run the interactive setup**:
   ```powershell
   .\start_watcher.ps1
   ```
   
   OR run directly:
   ```powershell
   .\auto_commit_watcher.ps1 -StartDate "2025-07-01" -EndDate "2025-12-31"
   ```

3. **Work normally**:
   - The script watches for file changes
   - Every time you save, it auto-commits with the current date in range
   - After 10 commits (default), it moves to the next date
   - Just keep coding and saving!

4. **Stop when done**:
   - Press `Ctrl+C` to stop the watcher
   - Progress is saved automatically
   - Can resume later

### Example Workflow

```powershell
# Terminal 1: Start the watcher
.\auto_commit_watcher.ps1 -StartDate "2025-07-01" -EndDate "2025-12-31" -CommitsPerDay 8

# Terminal 2 / VS Code: Work on your project
# - Edit index.html → Save → Auto commit #1 for 2025-07-01
# - Edit style.css → Save → Auto commit #2 for 2025-07-01
# - Edit script.js → Save → Auto commit #3 for 2025-07-01
# ... after 8 commits, automatically moves to 2025-07-02 ...
```

📖 **For complete documentation**, see `AUTO_COMMIT_GUIDE.md`

---

## 🎯 Which Script Should I Use?

- **Use `make_commit.ps1`** if you want precise control over each commit
- **Use `auto_commit_watcher.ps1`** if you want to automate the process and build history quickly
- **Use both!** Manual for important commits, auto watcher for regular development
