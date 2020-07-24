## Overview
Based on documentation to run jobs in GKE. Should not be confused with Kubernetes jobs. Jobs are represented by Kubernetes Job objects
https://cloud.google.com/kubernetes-engine/docs/how-to/jobs


### Setup
In addition to the setup in the root README, you should also do the following for this kubernetes jobs

1. Install minikube https://kubernetes.io/docs/tasks/tools/install-minikube/


#### Minikube
Minikube is a tool that makes it easy to run Kubernetes locally. Minikube runs a single-node Kubernetes cluster inside a Virtual Machine (VM) on your laptop for users looking to try out Kubernetes or develop with it day-to-day

```
# Start minikube
minikube start
```

### Simplest Example Without Additional Setup
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
