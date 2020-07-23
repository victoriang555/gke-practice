### Assuming you're in the cloned repo

##### ADMIN RESOURCES ######
# Create the default Batch admin resources in the "default" K8s namespace
./samples/defaultresources/create.sh

##### CREATE JOB #####
# Run the ComputePi Job in /samples/computepi
kubectl create -f pi-job.yaml

# Identify the pod associated with the job
kubectl get pods | grep [JOB_NAME]

# View the logs
kubectl logs pod/[POD_NAME]