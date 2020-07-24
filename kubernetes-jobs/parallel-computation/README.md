## Parallel execution for Jobs
There are three main types of task suitable to run as a Job:

#### Non-parallel Jobs
normally, only one Pod is started, unless the Pod fails.
the Job is complete as soon as its Pod terminates successfully.

#### Parallel Jobs with a fixed completion count
* specify a non-zero positive value for .spec.completions.
* the Job represents the overall task, and is complete when there is one successful Pod for each value in the range 1 to .spec.completions.
* not implemented yet: Each Pod is passed a different index in the range 1 to .spec.completions.

#### Parallel Jobs with a work queue
* do not specify .spec.completions, default to .spec.parallelism.
* the Pods must coordinate amongst themselves or an external service to determine what each should work on. For example, a Pod might fetch a batch of up to N items from the work queue.
* each Pod is independently capable of determining whether or not all its peers are done, and thus that the entire Job is done.
* when any Pod from the Job terminates with success, no new Pods are created.
* once at least one Pod has terminated with success and all Pods are terminated, then the Job is completed with success.
* once any Pod has exited with success, no other Pod should still be doing any work for this task or writing any output. They should all be in the process of exiting.


There are several different patterns for parallel computation, each with strengths and weaknesses. The tradeoffs are:

One Job object for each work item, vs. a single Job object for all work items. The latter is better for large numbers of work items. The former creates some overhead for the user and for the system to manage large numbers of Job objects.
Number of pods created equals number of work items, vs. each Pod can process multiple work items. The former typically requires less modification to existing code and containers. The latter is better for large numbers of work items, for similar reasons to the previous bullet.
Several approaches use a work queue. This requires running a queue service, and modifications to the existing program or container to make it use the work queue. Other approaches are easier to adapt to an existing containerised application.

![kubernetes-jobs-parallel-tradeoffs](parallel-jobs-kubernetes-tradeoffs.png)

![kubernetes-jobs-parallel-specifications](parallel-job-specifications.png)

