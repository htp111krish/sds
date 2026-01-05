param (
    [Parameter(Mandatory=$true)]
    [string]$StartDate,
    
    [Parameter(Mandatory=$true)]
    [string]$EndDate,
    
    [int]$CommitsPerDay = 10,
    
    [string]$Message = "Update project content",
    
    [int]$CheckIntervalSeconds = 5
)

# Validate Date formats
if ($StartDate -notmatch "^\d{4}-\d{2}-\d{2}") {
    Write-Host "Error: StartDate must be in YYYY-MM-DD format (e.g., 2025-07-01)" -ForegroundColor Red
    exit 1
}

if ($EndDate -notmatch "^\d{4}-\d{2}-\d{2}") {
    Write-Host "Error: EndDate must be in YYYY-MM-DD format (e.g., 2025-12-31)" -ForegroundColor Red
    exit 1
}

# Convert to DateTime objects
$startDateTime = [DateTime]::ParseExact($StartDate, "yyyy-MM-dd", $null)
$endDateTime = [DateTime]::ParseExact($EndDate, "yyyy-MM-dd", $null)

if ($startDateTime -gt $endDateTime) {
    Write-Host "Error: StartDate must be before or equal to EndDate" -ForegroundColor Red
    exit 1
}

# State file to track progress
$stateFile = ".commit_state.json"

# Initialize or load state
if (Test-Path $stateFile) {
    $state = Get-Content $stateFile | ConvertFrom-Json
    $currentDate = [DateTime]::ParseExact($state.currentDate, "yyyy-MM-dd", $null)
    $commitsToday = $state.commitsToday
    Write-Host "Resuming from saved state..." -ForegroundColor Cyan
    Write-Host "  Current Date: $($state.currentDate)" -ForegroundColor Cyan
    Write-Host "  Commits Today: $commitsToday/$CommitsPerDay" -ForegroundColor Cyan
} else {
    $currentDate = $startDateTime
    $commitsToday = 0
    Write-Host "Starting fresh..." -ForegroundColor Green
}

# Function to save state
function Save-State {
    param($date, $commits)
    $stateObj = @{
        currentDate = $date.ToString("yyyy-MM-dd")
        commitsToday = $commits
    }
    $stateObj | ConvertTo-Json | Set-Content $stateFile
}

# Function to get last commit hash
function Get-LastCommitHash {
    $hash = git rev-parse HEAD 2>$null
    return $hash
}

# Initial state
$lastCommitHash = Get-LastCommitHash
$lastFileHash = ""

Write-Host "`n========================================" -ForegroundColor Magenta
Write-Host "  AUTO COMMIT WATCHER STARTED" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "Date Range: $StartDate to $EndDate" -ForegroundColor Yellow
Write-Host "Commits per day: $CommitsPerDay" -ForegroundColor Yellow
Write-Host "Check interval: $CheckIntervalSeconds seconds" -ForegroundColor Yellow
Write-Host "Current Date: $($currentDate.ToString('yyyy-MM-dd'))" -ForegroundColor Green
Write-Host "Commits today: $commitsToday/$CommitsPerDay" -ForegroundColor Green
Write-Host "`nWatching for file changes... (Press Ctrl+C to stop)" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Magenta

while ($currentDate -le $endDateTime) {
    # Check for file changes
    $status = git status --porcelain
    
    if ($status) {
        # Calculate hash of current files to detect actual changes
        $statusString = $status -join "`n"
        $currentFileHash = [System.BitConverter]::ToString([System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($statusString)))
        
        if ($currentFileHash -ne $lastFileHash) {
            $lastFileHash = $currentFileHash
            
            # Generate a unique time for this commit (spread throughout the day)
            $hourOffset = [math]::Floor($commitsToday * 24 / $CommitsPerDay)
            $minuteOffset = ($commitsToday * 60) % 60
            $commitTime = "{0:00}:{1:00}:00" -f $hourOffset, $minuteOffset
            $fullDate = "$($currentDate.ToString('yyyy-MM-dd')) $commitTime"
            
            # Stage all changes
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Changes detected! Staging files..." -ForegroundColor Yellow
            git add . 2>&1 | Out-Null
            
            # Commit with custom message including commit number and custom date
            $commitMessage = "$Message (commit $($commitsToday + 1)/$CommitsPerDay)"
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Committing with date: $fullDate" -ForegroundColor Cyan
            
            # Use git commit with --date flag for both author and committer dates
            $env:GIT_AUTHOR_DATE = $fullDate
            $env:GIT_COMMITTER_DATE = $fullDate
            git commit -m $commitMessage --date="$fullDate" 2>&1 | Out-Null
            Remove-Item Env:\GIT_AUTHOR_DATE -ErrorAction SilentlyContinue
            Remove-Item Env:\GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
            
            # Push to GitHub
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Pushing to GitHub..." -ForegroundColor Cyan
            $pushResult = git push 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                $commitsToday++
                Write-Host "[$(Get-Date -Format 'HH:mm:ss')] SUCCESS! Commit $commitsToday/$CommitsPerDay pushed for $($currentDate.ToString('yyyy-MM-dd'))" -ForegroundColor Green
                
                # Save state
                Save-State -date $currentDate -commits $commitsToday
                
                # Check if we need to move to next day
                if ($commitsToday -ge $CommitsPerDay) {
                    $currentDate = $currentDate.AddDays(1)
                    $commitsToday = 0
                    $lastFileHash = ""  # Reset hash so next changes are detected
                    
                    if ($currentDate -le $endDateTime) {
                        Write-Host "`n========================================" -ForegroundColor Magenta
                        Write-Host "  MOVING TO NEXT DATE" -ForegroundColor Magenta
                        Write-Host "========================================" -ForegroundColor Magenta
                        Write-Host "New Date: $($currentDate.ToString('yyyy-MM-dd'))" -ForegroundColor Green
                        Write-Host "Commits today: 0/$CommitsPerDay" -ForegroundColor Green
                        Write-Host "========================================`n" -ForegroundColor Magenta
                        
                        Save-State -date $currentDate -commits $commitsToday
                    } else {
                        Write-Host "`n========================================" -ForegroundColor Green
                        Write-Host "  ALL DATES COMPLETED!" -ForegroundColor Green
                        Write-Host "========================================" -ForegroundColor Green
                        Write-Host "Date range $StartDate to $EndDate is complete." -ForegroundColor Yellow
                        Write-Host "Exiting watcher..." -ForegroundColor Yellow
                        Remove-Item $stateFile -ErrorAction SilentlyContinue
                        exit 0
                    }
                }
            } else {
                Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Push failed: $pushResult" -ForegroundColor Red
                # Clean up environment variables even on failure
                Remove-Item Env:\GIT_AUTHOR_DATE -ErrorAction SilentlyContinue
                Remove-Item Env:\GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
            }
            
            $lastCommitHash = Get-LastCommitHash
        }
    }
    
    # Wait before next check
    Start-Sleep -Seconds $CheckIntervalSeconds
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "  DATE RANGE COMPLETED!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "All commits for the date range have been processed." -ForegroundColor Yellow
Remove-Item $stateFile -ErrorAction SilentlyContinue
