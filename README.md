# CyberReportHub developer environment

CyberReportHub is a system that processes articles from rss feeds coming from the Open Cti platform,  and analyzes the articles to generate reports.

## Prerequisites
- A docker Engine (Docker Desktop is recommended)
- All repositories are cloned in same parent directory as this repository (folder names must be unmodified and match repository name)

## How to use
Ensure that all repositories are available in the same parent directory as this repository. They must be available on `../<reponame>`. Alternatively you can use the `./clone-repo.sh` script to auto clone all repositories.
You may also use `update-repo.sh` to auto pull latest versions from main for all repositories. 

The `setup-docker.sh` (`setup-docker.ps1` for windows) script will auto generate images and containers without starting those containers. If the image for a given project already exists, it will use that image. If you want to regenerate an
image, delete that image from your docker engine either via the UI (if using docker desktop) or using `docker rmi <image-id>`. The scripts will pull the current state of the repositories without doing any git commands.

To create containers for the environment in docker engine run the following commands inside the developer environment repository
- On Windows using powershell: `./setup-docker.ps1`
- On Mac or linux using terminal: `sh ./setup-docker.sh`

## Note: 
If there is a problem with the scripts to run the docker containers, just run: 	**docker compose --env-file ./local-variables.env up --no-start --detach** 
from inside the **developer repo** 

## How to add a new service
### 1. Add repository to check
Modify `setup-docker.sh` and `setup-docker.ps1` such that the `repositories` variable contains the **name of the git repository** in the list. 

## Running the project

## Important
1. All the used services are the ones starting by **crh** in our github organization. Please ignore the duplicate ones.
2. Make sure **crh-open-cti-integration** service is correctly configured according to the provided readme. https://github.com/SEG4910CapstoneProject/crh-open-cti-integration

Most services in this project are batch tasks (they will auto shutdown when completed). Only a small number of services will continuously run. They are:

- crh-database (both databases, postgres and mongo)
- crh-CyberReportHub-Site
- crh-enrichment-api
- crh-rest-api
- crh-email-service

### To run the project:

1. run: **docker compose --env-file ./local-variables.env build** from inside the **developer repo** (make sure you have the respective .env files and they are added to the **crh-open-cti-integration** service, the **crh-rss-feed-source** service, and the **crh-rest-api** service, contact the maintainers to get those .env files )

2. run: **docker compose --env-file ./local-variables.env up --no-start --detach**

3. start services in these orders using the play button in docker desktop: (or if on cmd,  do: **docker start** then the name of the service)

    31. crh-database (both databases, postgres and mongo)
    32. crh-open-cti-integration (using the method below)

        To run the crh-open-cti-integration service, in the command line, once inside the crh-open-cti-integration repo, run: **docker compose up -d**
        Note: If you just installed open cti, you might have the service running already, just skip this step then

        Go to localhost:8080 (where open cti lives), the .env file inside the open cti service will give you credentials to log in, once logged in, go to: Data-> Ingestion -> alienvault, make sure that all operations are completed and nothing is in progress, then go back and visit the bleeping computer rss ingestor, check the same, if all is completed, proceed next, if not, wait until it's the case, otherwise, you will end up with incomplete data.

    33. crh-rss-feed-source (When the logs stop showing for the rss service, stop the service from docker desktop and also stop the open-cti service.)

    34. crh-CyberReportHub-Site
    35. crh-enrichment-api
    36. crh-rest-api
    37. crh-email-service
    38. mailhog
    39. crh-web-scraping (it is fine if this service output log errors, just make sure to stop it when it's done if it doesnt shutdown on its own.)
    40. crh-feature-extractor
    41. crh-article-enricher
    42. crh-report-generator

You may access the site on `localhost:80`. You are done. 

### 2. Add service to docker compose file

In the docker compose file (`compose.yml`):
- Create a service named the same as the git repository
- If the service is build via a DOCKERFILE, add `build: ../<repositoryname>` assuming dockerfile is on root of the repository. If it is not on root, specify the directory.

- If a docker compose for the service already exists in the git repository, add property `extends` with `file` amd `service` properties defining the file and services to be used.
Example:
```
extends:
    file: ../Databases/compose.yml
    service: postgres
```

- Add property `restart: no`
- Add environment variables using the environment property
  - All environment variables must be added and given test values to `local-variables.env`
  - **The values and passwords in `local-variables.env` must not contain sensitive data as it is added to the git repository**

- If the service depends on another service to run (for example depends on postgres database to run) add the `depends_on` property
Example:
```
depends_on:
    - postgres
    - mongo
```

- If other services will depend on this service running (For example database services) add the following as a property of the service: 
```
healthcheck:
    test: ["CMD", "curl", "-f", "http://localhost:${REPLACE ME WITH PORT}"]
    interval: 1m
    timeout: 10s
    retries: 3
    start_period: 10s
    start_interval: 5s
```

# Troubleshooting

## I am getting connection refused localhost

Your system environment variables is overriding the environment variables set by `local-variables.env` remove or disable those variables.

## Nothing is happing when I run the script OR I am getting a security error on Windows

- Ensure you have Docker desktop V3
- On PowerShell you can run the command: `powershell -ExecutionPolicy Bypass -File setup-docker.ps1`
- Try running the `./setup-docker.sh` script instead of the powershell script using a 3rd party shell (like git bash)
