# Get the parent directory of the current directory
$parentDir = (Get-Location).Parent.FullName

# Check if the parent directory exists
if (-not (Test-Path $parentDir)) {
    Write-Host "Error: Parent directory '$parentDir' does not exist!" -ForegroundColor Red
    exit 1
}

# Loop through each subdirectory in the parent directory
Get-ChildItem -Path $parentDir -Directory | ForEach-Object {
    $dir = $_.FullName

    # Check if the directory is a Git repository (contains a .git directory)
    if (Test-Path "$dir\.git") {
        # Change to the repository directory
        Write-Host "Updating repository: $dir"
        Set-Location -Path $dir

        # Ensure we're on the main branch and update it
        Write-Host "Switching to main branch and pulling updates..."
        git checkout main  # Switch to the main branch
        git pull origin main  # Pull from the remote main branch

        # Check if the pull was successful
        if ($?) {
            Write-Host "Successfully updated the main branch in: $dir" -ForegroundColor Green
        } else {
            Write-Host "Error updating repository: $dir" -ForegroundColor Red
        }

        # Return to the parent directory
        Set-Location -Path $parentDir
    } else {
        Write-Host "Skipping non-Git directory: $dir" -ForegroundColor Yellow
    }
}

Write-Host "Done updating repositories." -ForegroundColor Cyan