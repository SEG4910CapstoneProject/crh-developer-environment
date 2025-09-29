#!/bin/bash

repositories=(
	"crh-web-scraping"
	"crh-database"
	"crh-rss-feed-source"
	"crh-feature-extractor"
	"crh-rest-api"
	"crh-report-generator"
	"crh-CyberReportHub-Site"
	"crh-enrichment-api"
	"crh-article-enricher"
	"crh-open-cti-integration"
	"crh-email-service"
)

foundAll=1

# Verify all repos exist
for repo in ${repositories[@]}; do
	if [ ! -d "../$repo" ]; then
		echo "$repo does not exist." 
		foundAll=0
	fi
done

if ! command -v docker &> /dev/null; then
	echo "docker command not found. Please make sure you have installed all dependencies"
	read -n1 -r -p "Press any key to continue..." key
	exit
fi


if [ $foundAll = 1 ]; then
	echo "Found all required repos and dependencies"
	docker compose --env-file ./local-variables.env up --no-start --detach 
else 
	printf "\nNot all repositories were found. Please make sure you clone the above repositories in the same directory as this project\n\n"
fi

read -n1 -r -p "Press any key to continue..." key
