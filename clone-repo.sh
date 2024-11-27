#!/bin/bash

# Array of repository URLs
REPO_LIST=(
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
cd ..

# Loop through each repository URL in the array
for repo_url in "${REPO_LIST[@]}"; do
  # Skip empty URLs (if any) or lines starting with # (for comments)
  if [[ -z "$repo_url" || "$repo_url" =~ ^# ]]; then
    continue
  fi
  
  # Clone the repository
  echo "Cloning repository: $repo_url"
  git clone "$repo_url"

  # Check if the clone was successful
  if [ $? -ne 0 ]; then
    echo "Error cloning repository: $repo_url"
  fi
done

echo "Done cloning repositories."