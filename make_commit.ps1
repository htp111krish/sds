param (
    [Parameter(Mandatory=$true)]
    [string]$Date,
    
    [string]$Message = "Update project content"
)

# Validate Date format
if ($Date -notmatch "^\d{4}-\d{2}-\d{2}") {
    Write-Host "Error: Date must be in YYYY-MM-DD format (e.g., 2023-05-20)" -ForegroundColor Red
    exit 1
}

# Check if there are changes to commit
$status = git status --porcelain
if (-not $status) {
    Write-Host "No changes detected to commit." -ForegroundColor Yellow
    Write-Host "  -> If you just want a green dot, modify a file first."
    Write-Host "  -> If you wrote code, make sure you saved the files."
    exit
}

# Stage all changes in the current folder
Write-Host "Staging all changes..."
git add .

# Set environment variables for the date
$fullDate = "$Date 12:00:00"
$env:GIT_AUTHOR_DATE = $fullDate
$env:GIT_COMMITTER_DATE = $fullDate

# Commit
Write-Host "Committing with date: $fullDate"
git commit -m "$Message"

# Clean up environment variables
Remove-Item Env:\GIT_AUTHOR_DATE
Remove-Item Env:\GIT_COMMITTER_DATE

Write-Host "Success! Code committed as of $Date." -ForegroundColor Green
