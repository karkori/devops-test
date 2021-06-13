# DevOps Test
This is a small node.js webapp using Express, and it is dockerized with Docker. The objective with this mini-project is to implement the different tools and techniques of the DevOps methodology. To Lunch the node processes I've implemented the forever daemon tool.

## Running the app
```
npm start
```
The server is listening on localhost port 3000:
```
http://localhost:3000/
```
We can access two resources: ***/*** and **/users**

## Dockerizing
In the main directory of the project we can find the dockerfile. We can use it to build the docker image. In this image I have based on the Ubuntu base image to configure the server. I have installed and configured in it several tools that will allow us to build, deploy and remotely access the host.
### Installed tools:
sudo, curl, gnupg, openssh-server, net-tools, nodejs and forever daemon tool.
### Build Docker image
```
sudo docker build -t devops-test .
```

### Run Docker container
```
sudo docker run -p 3000:3000 devops-test
```
### Stop Docker container
```
sudo docker stop $(docker ps -lq)
```
Note that the "docker ps -lq" command returns the last ran container ID.

Other commands:
- **Stop all containers**: sudo docker stop $(docker ps -a -q)
- **Remove all containers**: sudo docker rm $(docker ps -a -q)
- **Remove all generated images**: sudo docker rmi $(docker images -q)

### Persist data
Persist data generated by and used by Docker containers (node.js app logs in this case) with -v argument:
```
docker run -d -p 80:3000 -v /webapp/logs:./logs/ --name devops-test -it devops-test:latest
```
The -v argument (or --volume) lets us to mount a volume on the local machine to persist any container data. In this case:
- /webapp/logs: is the directory where we want to save the data on the local machine.
- ./logs/: is the directory where the app has generated datas.

## Docker Ansible Automation
Please visit: https://github.com/karkori/docker-ansible-automation.git
#### Other links:
- Dockerhub Repos for Devops-Test: https://hub.docker.com/repository/docker/bourarach/devops-test
- Dockerhub Repos for the Docker Ansible Automation: https://hub.docker.com/repository/docker/bourarach/ubuntu-docker
