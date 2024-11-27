
$repositories = @(
	"crh-web-scraping"
	"crh-database"
	"crh-rss-feed-source"
	"crh-feature-extractor"
	"crh-rest-api"
	"crh-report-generator"
	"crh-CyberReportHub-Site"
	"crh-enrichment-api"
	"crh-article-enricher"
)

$foundAll = 1

# Verify all repos exist
foreach ($repo in $repositories) {
	if (-Not (Test-Path -Path "../$repo")) {
		echo "$repo does not exist." 
		$foundAll = 0
	}
}

if (-Not (Get-Command docker -errorAction SilentlyContinue)) {
	echo "docker command not found. Please make sure you have installed all dependencies"
	pause
	Exit
}

if ($foundAll -eq 1) {
	echo "Found all required repos and dependencies"
	docker compose --env-file ./local-variables.env up --no-start --detach 
} else {
	echo "\nNot all repositories were found. Please make sure you clone the above repositories in the same directory as this project\n\n"
}

pause
