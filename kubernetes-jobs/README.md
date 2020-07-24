## Overview
How to use Kubernetes jobs. Practiced workflows based on:
* https://courses.edx.org/courses/course-v1:LinuxFoundationX+LFS158x+2T2019/course/
* https://kubernetes.io/docs/concepts/workloads/controllers/job/
* https://kubernetes.io/docs/tasks/job/

### How Jobs Work
A Job creates one or more Pods and ensures that a specified number of them successfully terminate. As pods successfully complete, the Job tracks the successful completions. When a specified number of successful completions is reached, the task (ie, Job) is complete. Deleting a Job will clean up the Pods it created.

A simple case is to create one Job object in order to reliably run one Pod to completion. The Job object will start a new Pod if the first Pod fails or is deleted (for example due to a node hardware failure or a node reboot).

You can also use a Job to run multiple Pods in parallel. This is the use case for Batch. See the [parallel-computation readme](parallel-computation/README.md) for ways to implement  parallel job execution.

Find example job specs and explanations of them in [job-specs](job-specs)
Learn how to create job queues in [job-queues](job-queues)

### How to run jobs
```
# Create the job from a jobspec
kubectl apply -f <job-spec-filepath>

# If parallel, check the pods and list changes as they happen
kubectl get pods --watch -o wide &

# If parallel, stop getting the pods 
pkill -f "kubectl get pods --watch -o wide"

# If a single pod, get the pod status
kubectl get pod -l job-name=<job-name>

# Remove the job
kubectl delete jobs <job-name>
```