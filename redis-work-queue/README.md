# Overview
Use Redis to store the work items for the queue. Run a Kubernetes Job with multiple parallel worker processes in a given pod. Each pod is created, it picks up one unit of work from a task queue, processes it, and repeats until the end of the queue is reached. Based on docs https://kubernetes.io/docs/tasks/job/fine-parallel-processing-work-queue/

Here is an overview of the steps in this example:

1. Start a storage service to hold the work queue. In this example, we use Redis to store our work items. In the previous example, we used RabbitMQ. In this example, we use Redis and a custom work-queue client library because AMQP does not provide a good way for clients to detect when a finite-length work queue is empty. In practice you would set up a store such as Redis once and reuse it for the work queues of many jobs, and other things.
2. Create a queue, and fill it with messages. Each message represents one task to be done. In this example, a message is just an integer that we will do a lengthy computation on.
3. Start a Job that works on tasks from the queue. The Job starts several pods. Each pod takes one task from the message queue, processes it, and repeats until the end of the queue is reached.

## Notes
1. In our example, our tasks are just strings to be printed.

## Setup
Make sure you do the setup in the root directory readme. You should have a cluster ready for this workflow.