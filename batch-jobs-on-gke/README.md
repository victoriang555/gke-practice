Notes based on docs
https://cloud.google.com/kubernetes-engine/docs/how-to/batch/running-job#running_a_single-task_job

Repo: https://github.com/GoogleCloudPlatform/Kbatch.git

NOTE: Batch on GKE is in beta, I requested access to the beta, but probably won't be granted. 

### Submit jobs
There are two ways to submit jobs in Batch: ksub and kubectl. The ksub command can submit shell scripts as jobs, and kubectl can submit jobs using yaml files.

In this "practice", I will use kubectl

Reference the computepi directory for a complete example

### Running jobs with dependencies
With dependencies, you can run some jobs only when specific conditions related to previous jobs have occurred. The Beta version supports 3 dependency types:

1. SUCCESS - 
A job will run only if all the jobs it depends on have succeeded.
2. FAILED -
A job will run only if all the jobs it depends on have failed.
3. FINISHED -
A job will run only once all the jobs it depends on have completed.

If the system decides not to run a job because a dependency cannot be met, Batch marks the job as Failed. For example, if job1 depends on job2 with the dependency type Success and job2 fails, then job1 never runs and is considered to have failed. Otherwise, job failure and success are determined by the success or failure of the Pod associated with the job as defined by the Kubernetes Pod lifecycle

DEPENDENCIES
Before running this sample job, you must set up a Google Cloud Filestore instance, in the same zone that is your GKE cluster's node location) for inputs / outputs.