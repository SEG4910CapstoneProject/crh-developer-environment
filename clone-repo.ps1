# Array of repository URLs
$repoList = @(
  "https://github.com/SEG4910CapstoneProject/crh-feature-extractor.git"
  "https://github.com/SEG4910CapstoneProject/crh-CyberReportHub-Site.git"
  "https://github.com/SEG4910CapstoneProject/crh-enrichment-api.git"
  "https://github.com/SEG4910CapstoneProject/crh-article-enricher.git"
  "https://github.com/SEG4910CapstoneProject/crh-database.git"
  "https://github.com/SEG4910CapstoneProject/crh-rest-api.git"
  "https://github.com/SEG4910CapstoneProject/crh-rss-feed-source"
  "https://github.com/SEG4910CapstoneProject/crh-web-scraping"
  "https://github.com/SEG4910CapstoneProject/crh-report-generator"
)

# Go to the parent directory
Set-Location ..

# Loop through each repository URL in the array
foreach ($repoUrl in $repoList) {
    # Skip empty URLs or lines starting with # (for comments)
    if ([string]::IsNullOrWhiteSpace($repoUrl) -or $repoUrl.StartsWith('#')) {
        continue
    }

    # Clone the repository
    Write-Host "Cloning repository: $repoUrl"
    git clone $repoUrl

    # Check if the clone was successful
    if ($?) {
        Write-Host "Successfully cloned: $repoUrl" -ForegroundColor Green
    } else {
        Write-Host "Error cloning repository: $repoUrl" -ForegroundColor Red
    }
}

Write-Host "Done cloning repositories."