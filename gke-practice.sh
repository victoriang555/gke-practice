## GCP codelab 

#### SETUP ####
# Get the accounts
gcloud auth list

# Get the list of projects
gcloud config list project

# Set the project, if not automatically set
gcloud config set project <PROJECT_ID>

# Set the default zone
gcloud config set compute/zone us-central1-f


#### CLUSTER #####
# Start up a cluster
gcloud container clusters create codelab

#### GET CODE ####
git clone https://github.com/googlecodelabs/orchestrate-with-kubernetes.git
cd orchestrate-with-kubernetes/kubernetes

#### DEPLOYMENT ####
# Launch a single instance of the nginx container. This creates a deployment
# NOTE: Deployments keep our Pods up and running, even when the nodes they run on fail
# NOTE: This command is different than the code lab - the code lab code is outdated. Needs a new kubectl v1.18.2
kubectl create deployment nginx --image=nginx:1.10.0

# View the running nginx container
kubectl get pods

# Expose the nginx container outside of Kubernetes
# Kubernetes creates an external Load Balancer with a public IP address attached to it
# NOTE: GKE has a public load balancer
kubectl expose deployment nginx --port 80 --type LoadBalancer

# Check the services and make sure there's an external IP address
# If there isn't, check again - might take a bit
kubectl get services

##### MONOLITH POD CREATION #####
# Create the monolith pod
kubectl create -f pods/monolith.yaml

# Examine pods
kubectl get pods

# Get more information about the monolith pod
kubectl describe pods monolith

##### INTERACT WITH PODS #####
# Map a local port to a port inside the monolith pod
# NOTE: This command must be run in a separate terminal tab 
kubectl port-forward monolith 10080:80

# Talk to the pod
curl http://127.0.0.1:10080

# View the logs for the monolith pod
kubectl logs monolith

# View a stream of logs in a new terminal tab
# NOTE: Best to run this command in a new tab
kubectl logs -f monolith 

##### CREATING A SERVICE #######
# Create a secure pod that can handle https traffic
# Create the secure-monolith pods and it's configuration data
kubectl create secret generic tls-certs --from-file tls/
kubectl create configmap nginx-proxy-conf --from-file nginx/proxy.conf
kubectl create -f pods/secure-monolith.yaml



##### TROUBLESHOOTING #####
# To run an interactive shell in side the monolith pod
kubectl exec monolith --stdin --tty -c monolith /bin/sh

# Test external connectivity
ping -c 3 google.com

# Logout of the interactive shell
exit

