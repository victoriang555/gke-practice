# Overview
Based on documentation to run jobs in GKE. Should not be confused with Kubernetes jobs. Jobs are represented by Kubernetes Job objects
https://cloud.google.com/kubernetes-engine/docs/how-to/jobs

## How to create a job
```
kubectl apply -f <config file path>
```

## Job Config Files
This directory contains various job config files, and those are described below.


### [Multiple pods config](config-2.yaml)
If you have a parallel Job, you can set a completion count using the optional completions field. This field specifies how many Pods should terminate successfully before the Job is complete. The completions field accepts a non-zero, positive value.

Omitting completions or specifying a zero value causes the success of any Pod to signal the success of all Pods.

### [Concurrent pod running, true parallelism config](config-3.yaml)
By default, Job Pods do not run in parallel. The optional parallelism field specifies the maximum desired number of Pods a Job should run concurrently at any given time.

The actual number of Pods running in a steady state might be less than the parallelism value if the remaining work is less than the parallelism value. If you have also set completions, the actual number of Pods running in parallel does not exceed the number of remaining completions. A Job may throttle Pod creation in response to excessive Pod creation failure.

### [Retries config](config.yaml)
By default, a Job runs uninterrupted unless there is a failure, at which point the Job defers to the backoffLimit. The backoffLimit field specifies the number of retries before marking the job as failed; the default value is 6. The number of retries applies per Pod, not globally. This means that if multiple Pods fail (when parallelism is greater than 1), the job continues to run until a single Pod fails backoffLimit of times. Once the backoffLimit has been reached, the Job is marked as failed and any running Pods will be terminated.

For example, in our example job, we set the number of retries to 4

### Notes on jobs
Learn more about job specs [here](/kubernetes-jobs/job-specs)

In GKE, a Job is a controller object that represents a finite task. Jobs differ from other controller objects in that Jobs manage the task as it runs to completion, rather than managing an ongoing desired state (such as the total number of running Pods).

Jobs are useful for large computation and batch-oriented tasks. Jobs can be used to support parallel execution of Pods. You can use a Job to run independent but related work items in parallel: sending emails, rendering frames, transcoding files, scanning database keys, etc. However, Jobs are not designed for closely-communicating parallel processes such as continuous streams of background processes.

In GKE, there are two types of Jobs:

1. Non-parallel Job: A Job which creates only one Pod (which is re-created if the Pod terminates unsuccessfully), and which is completed when the Pod terminates successfully.
2. Parallel jobs with a completion count: A Job that is completed when a certain number of Pods terminate successfully. You specify the desired number of completions using the completions field. Omitting completions or specifying a zero value causes the success of any Pod to signal the success of all Pods.

Jobs are represented by Kubernetes Job objects. When a Job is created, the Job controller creates one or more Pods and ensures that its Pods terminate successfully. As its Pods terminate, a Job tracks how many Pods completed their tasks successfully. Once the desired number of successful completions is reached, the Job is complete.

Similar to other controllers, a Job controller creates a new Pod if one of its Pods fails or is deleted.

### Notes about this practice workflow
1. This Job computes pi to 2000 places then prints it.

## Setup
In addition to the setup in the root README, you should also do the following for this kubernetes jobs

1. Install minikube https://kubernetes.io/docs/tasks/tools/install-minikube/


### Minikube
Minikube is a tool that makes it easy to run Kubernetes locally. Minikube runs a single-node Kubernetes cluster inside a Virtual Machine (VM) on your laptop for users looking to try out Kubernetes or develop with it day-to-day

```
# Start minikube
minikube start
```

## Simplest Example Without Additional Setup
```
# This assumes you already have kubectl installed
kubectl apply -f https://kubernetes.io/examples/controllers/job.yaml
# Expected output
job.batch/pi created
```
```
# Check the job status
kubectl describe jobs/pi
# Expected output
Name:           pi
Namespace:      default
Selector:       controller-uid=c9948307-e56d-4b5d-8302-ae2d7b7da67c
Labels:         controller-uid=c9948307-e56d-4b5d-8302-ae2d7b7da67c
                job-name=pi
Annotations:    kubectl.kubernetes.io/last-applied-configuration:
                  {"apiVersion":"batch/v1","kind":"Job","metadata":{"annotations":{},"name":"pi","namespace":"default"},"spec":{"backoffLimit":4,"template":...
Parallelism:    1
Completions:    1
Start Time:     Mon, 02 Dec 2019 15:20:11 +0200
Completed At:   Mon, 02 Dec 2019 15:21:16 +0200
Duration:       65s
Pods Statuses:  0 Running / 1 Succeeded / 0 Failed
Pod Template:
  Labels:  controller-uid=c9948307-e56d-4b5d-8302-ae2d7b7da67c
           job-name=pi
  Containers:
   pi:
    Image:      perl
    Port:       <none>
    Host Port:  <none>
    Command:
      perl
      -Mbignum=bpi
      -wle
      print bpi(2000)
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Events:
  Type    Reason            Age   From            Message
  ----    ------            ----  ----            -------
  Normal  SuccessfulCreate  14m   job-controller  Created pod: pi-5rwd7
```
```
# View the completed pods of a job
kubectl get pods
```
```
# View a list of pods that belong to a job in a machine readable form
pods=$(kubectl get pods --selector=job-name=pi --output=jsonpath='{.items[*].metadata.name}')
echo $pods
```
