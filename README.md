# Overview
Practice using GKE (Google Kubernetes Engine) with various features and workflows. From the perspective of a developer, meaning this excludes most devops workflows. 

All based on the GCP codelabs. This includes various parts of the labs that I found most useful, in a condensed, hopefully consumable format.

## General Setup
1. Setup the google cloud sdk (if you want to run in your local terminal) https://cloud.google.com/sdk/docs/downloads-interactive
2. Setup kubectl (if you want to run in your local terminal) [install-and-configure-kubectl.md](orchestrate-with-kubernetes/setup/install-and-configure-kubectl.md)
3. Setup the Cloud Shell (if you don't want to run in your local terminal)
4. Setup a project. You can reuse the same project for multiple clusters [setup-project-via-terminal](setup/setup-project.sh) or [setup-project-in-ui](setup-project-in-ui.md)
5. Setup a cluster. You should create a new cluster on the same project for each of the practice workflows. Each workflow has a different cluster name. [setup-cluster](setup/setup-cluster.sh)

## Workflows
I recommend going in the order listed below, but they're completely separate workflows, so you can go in any order you want. 

### [Kubernetes Jobs](kubernetes-jobs)
How to use kubernetes in general, as well as some specific workflows.

Includes steps to:
* Create a job queue
* Create jobs specs
* Create jobs
* Execute jobs in parallel

### [Orchestrate With GKE](orchestrate-with-gke)
The general setup for GKE

Includes steps to:
* Create cluster
* Create pods
* Create services
* Create, expose, and scale deployments
* Configure networking between nodes

### [Nodejs container in GKE](nodejs-container-gke)
Run a nodejs application in GKE and scale it.

Includes steps to:
* Build docker container
* Publish container to Google Container Registry
* Create deployment
* Allow external traffic
* Scale up the service
* Roll out an upgrade to the service

### [Cloudrun on GKE](cloudrun-on-gke)
Deploy cloudrun on GKE

Includes steps to:
* Setup a cloudrun-enabled cluster
* Deploy to cloudrun on GKE
* Access the deployed service

### [Batch jobs on GKE](batch-jobs-on-gke)
Beta workflow for batch jobs in GKE

Includes steps to:
* Create jobs
* Run jobs with dependencies


## Resources
1. Kubectl commands https://kubernetes.io/docs/reference/kubectl/overview/