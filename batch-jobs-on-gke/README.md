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

Success
A job will run only if all the jobs it depends on have succeeded.
Failed
A job will run only if all the jobs it depends on have failed.
Finished
A job will run only once all the jobs it depends on have completed.