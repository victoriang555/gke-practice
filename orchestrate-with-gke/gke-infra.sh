## GCP codelab 

#### SETUP ####
# NOTE: if you already did the setup in the main directory README, you can skip this section
# Get the Google Cloud accounts
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

# Create the secure monolith service
kubectl create -f services/monolith.yaml

# Allow traffic to the monolith service on the exposed nodeport
# NOTE: Normally, Kubernetes would handle this port assignment for us -- in this codelab we chose one so that it's easier to configure health checks, later on.
gcloud compute firewall-rules create allow-monolith-nodeport \
  --allow=tcp:31000

# NOTE: For practice, the existing secure monolith pod doesn't have the secure=enabled label
# This label is needed for the monolith service to find it 
# Let's add it
kubectl label pods secure-monolith 'secure=enabled'

# Check labels on all of the pods
kubectl get pods secure-monolith --show-labels

# View the endpoints on the monolith service
kubectl describe services monolith | grep Endpoints

# Now that everything is setup -- we should be able to hit the secure-monolith service from outside the cluster without using port forwarding. First, let's get an IP address for one of our nodes. And then try hitting the secure-monolith service using curl.
# Get the list of running instances/workloads
gcloud compute instances list

# Hit the secure-monolith service
# Paste the external IP of the secure monolith service into the below command
curl -k https://<EXTERNAL_IP>:31000

##### CREATING DEPLOYMENTS ######
# We're going to break our monolith app into three separate pieces:
# auth - Generates JWT tokens for authenticated users.
# hello - Greet authenticated users.
# frontend - Routes traffic to the auth and hello services.

# Create deployment object
kubectl create -f deployments/auth.yaml

# Create the auth service
kubectl create -f services/auth.yaml

# Create and expose the hello deployment
kubectl create -f deployments/hello.yaml
kubectl create -f services/hello.yaml

# Create and expose the frontend
kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
kubectl create -f deployments/frontend.yaml
kubectl create -f services/frontend.yaml

##### INTERACT WITH FRONTEND ####
# Get the external IP and curl 
kubectl get services frontend
curl -k https://<EXTERNAL-IP>

##### CLEANUP #####
# Delete the cluster
gcloud container clusters delete codelab

# OR cleanup using the cleanup script
chmod +x cleanup.sh
./cleanup.sh

##### TROUBLESHOOTING #####
# To run an interactive shell in side the monolith pod
kubectl exec monolith --stdin --tty -c monolith /bin/sh

# Test external connectivity
ping -c 3 google.com

# Logout of the interactive shell
exit

