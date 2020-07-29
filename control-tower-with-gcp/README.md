# Control Tower with GCP
Easily run ConcourseCI in GCP. This workflow is based off documentation from https://concourse-ci.org/quick-start.html and https://github.com/EngineerBetter/control-tower/tree/0.12.2

## Cost
By default, control-tower deploys to the AWS eu-west-1 (Ireland) region or the GCP europe-west1 (Belgium) region, and uses spot instances for large and xlarge Concourse VMs. The estimated monthly cost is as follows:
![control-tower-in-gcp-cost](control-tower-gcp-cost.png)


## Setup

1. On GCP you must also ensure the following APIs are activated in your GCP project:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Compute Engine API (gcloud services enable compute.googleapis.com)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Identity and Access Management (IAM) API (gcloud services enable iam.googleapis.com)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Cloud Resource Manager API (gcloud services enable cloudresourcemanager.googleapis.com)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Cloud SQL Admin API (gcloud services enable sqladmin.googleapis.com)

2. A IAM Primitive role of roles/owner for the target GCP Project is required

3. Download the latest release of Control Tower

More info: https://github.com/EngineerBetter/control-tower/blob/master/docs/prerequisites.md

## Running
```
GOOGLE_APPLICATION_CREDENTIALS=<path/to/googlecreds.json> \
  control-tower deploy --iaas gcp <your-project-name>
```

