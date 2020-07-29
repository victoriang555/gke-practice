#### SETUP ####
# Need to have run the general setup steps in the root readme
# The name of the cluster we're referencing in this practice is "hello-world"
# If running locally, set your project id variable
export DEVSHELL_PROJECT_ID = <YOUR-GOOGLE-PROJECT-ID>

#### GET THE CODE ####
git clone https://github.com/GoogleCloudPlatform/nodejs-docs-samples.git
cd nodejs-docs-samples/containerengine/hello-world/

#### BUILD THE CONTAINER ####
# They saved the project id in a local variable
docker build -t gcr.io/$DEVSHELL_PROJECT_ID/hello-node:1.0 .

#### PUBLISH THE CONTAINER ####
# First, set up Docker to push to Google Container Registry
gcloud auth configure-docker
# Publish container
docker push gcr.io/$DEVSHELL_PROJECT_ID/hello-node:v1

#### CREATE DEPLOYMENT ####
# create a Deployment that manages a Pod. 
# The Pod runs a Container based on the provided Docker image
kubectl create deployment hello-node \
    --image=gcr.io/$DEVSHELL_PROJECT_ID/hello-node:v1 \
    --port=8080
# Check the deployment
kubectl get deployments
# View the pod created by the deployment
kubectl get pods
# This command starts up one copy of the docker image on one of the nodes in the cluster.
kubectl run hello-node --image=gcr.io/$DEVSHELL_PROJECT_ID/hello-node:v1 --port=8080

#### ALLOW EXTERNAL TRAFFIC ####
# By default a pod is only accessible to other machines inside the cluster. 
# In order to use the node.js container that was created it needs to be exposed as a service.
# Typically, you would create a yaml file with the configuration for the service. 
# In this example, we are going to skip this step and instead directly create the service on the command line.
# kubectl expose creates a service, the forwarding rules for the load balancer, 
# and the firewall rules that allow external traffic to be sent to the pod. 
# The --type=LoadBalancer flag creates a Google Cloud Network Load Balancer that will accept external traffic.
kubectl expose deployment hello-node --type=LoadBalancer --port=8080

# Get the EXTERNAL IP address of your service
kubectl get svc hello-node

#### SCALE UP THE SERVICE ####
# Suppose you suddenly need more capacity for your application; 
# you can simply tell the replication controller to manage a new number of replicas for your pod:
kubectl scale deployment hello-node --replicas=4

#### ROLL OUT UPGRADE TO SERVICE ####
# First, modify server.js response message
# build and publish a new container image to the registry with an incremented tag (v2 in this case)
docker build -t gcr.io/$DEVSHELL_PROJECT_ID/hello-node:v2 . 
docker -- push gcr.io/$DEVSHELL_PROJECT_ID/hello-node:v2

# We're now ready for Kubernetes to smoothly update our replication controller to the new version of the application
# In order to change the image label for our running container, 
# we will need to edit the existing hello-node deployment
# and change the image from gcr.io/PROJECT_ID/hello-node:v1 to gcr.io/PROJECT_ID/hello-node:v2.

# To do this, we will use the kubectl set image command. 
# This will trigger a new deployment rollout with the new updated image.
kubectl set image deployment.apps/hello-node \
    hello-node=gcr.io/$DEVSHELL_PROJECT_ID/hello-node:v2

# To track progress of the rollout, you can use this command 
kubectl rollout status deployment hello-node

#### CLEANUP ####
# Delete the service and deployment
kubectl delete service,deployment hello-node

# Delete the cluster
gcloud container clusters delete hello-world --zone=us-central1-f

# Delete images from the container registry repo
gcloud container images delete gcr.io/$DEVSHELL_PROJECT_ID/hello-node:v1
gcloud container images delete gcr.io/$DEVSHELL_PROJECT_ID/hello-node:v2 
