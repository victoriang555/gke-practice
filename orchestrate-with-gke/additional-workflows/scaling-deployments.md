## Scaling Deployments

Behind the scenes Deployments manage ReplicaSets. Each deployment is mapped to one active ReplicaSet. Use the kubectl get replicasets command to view the current set of replicas.

```
kubectl get replicasets
```

ReplicaSets are scaled through the Deployment for each service and can be scaled independently. Use the `kubectl scale` command to scale the hello deployment:

```
kubectl scale deployments hello --replicas=3
```

```
kubectl describe deployments hello
```

```
kubectl get pods
```

```
kubectl get replicasets
