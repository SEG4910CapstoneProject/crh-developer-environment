# CyberReportHub developer environment

CyberReportHub is a system that collects articles from rss feeds and analyzes the articles to generate reports.

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

## How to add a new service
### 1. Add repository to check
Modify `setup-docker.sh` and `setup-docker.ps1` such that the `repositories` variable contains the **name of the git repository** in the list. 

## Running the project

Most services in this project are batch tasks (they will auto shutdown when completed). Only a small number of services will continuously run. They are:

- crh-database (both databases, postgres and mongo)
- crh-CyberReportHub-Site
- crh-enrichment-api
- crh-rest-api

To run the project, start the above first then run the tasks in this order.

1. crh-rss-feed-source
2. crh-web-scraping
3. crh-feature-extractor
4. crh-article-enricher
5. crh-report-generator

You may access the site on `localhost:80`.

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
