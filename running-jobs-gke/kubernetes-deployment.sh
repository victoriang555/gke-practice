# Let’s create a Kubernetes Deployment using an existing image named echoserver, which is a simple HTTP server and expose it on port 8080 using --port.
kubectl create deployment hello-minikube --image=k8s.gcr.io/echoserver:1.10

# 