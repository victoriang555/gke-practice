#  
wget https://concourse-ci.org/docker-compose.yml
docker-compose up -d
# Concourse will be running at localhost:8080. 
# You can log in with the username/password as test/test.


# Next, install fly CLI by downloading it from the web UI 
# and target your local Concourse as the test user
docker-compose up -d