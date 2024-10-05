=============================================================================================
Notes
=============================================================================================
# Docker using "namespace technology" refers to the way Docker isolates various aspects of containers using Linux namespaces
# Docker is client-server architecture, Client (docker cli) - Server (docker daemon), docker cli hits API endpoints which interacts with docker daemon
# Docker properties (Lightweight, Resource Efficiency, Portability, Isolation, Scalability, Version Control-Docker Hub, Rapid Deployment, Consistency)


=============================================================================================
All docker commands
=============================================================================================
docker --help | less


=============================================================================================
Container commands
=============================================================================================
# You can give first 3-4 unique numbers of your container id instead of full id
# You can use more than one conatiner id after commands i.e. <container_id_1> <container_id_2> ...

# List all containers (running & stopped) 
docker container ls -a
docker container ls -aq
docker ps -a

# Create
docker container create <container_id_or_name>

# Rename
docker container rename <container_id_or_name> <new_container_name>

# Start
docker container start <container_id_or_name>

# Stop (exit) - gracefully stops
docker container stop <container_id_or_name>

# Kill - forcefully stops
docker container kill <container_id_or_name>

# Pause (suspend)
docker container pause <container_id_or_name>

# Unpause (resume)
docker container unpause <container_id_or_name> 

# Restart
docker container restart <container_id_or_name>

# Remove (destroy)
docker container rm <container_id_or_name>
docker container prune -f
docker container rm -f $(docker container ls -aq)

# Run (it pulls image, creates and starts a container)
docker container run ubuntu
docker container run ubuntu cat /etc/os-release

# Running a deattached container to avoid freezing of terminal
docker container run -d ubuntu sleep 30

# Naming 
docker container run --name <your_container_name> <image>

# Inspect 
docker container inpect <container_id_or_name> | less

# Interact
docker container run -it ubuntu /bin/bash

# Keep the container running, first get inside it then type
CTRL + P followed by CTRL + Q

# Logs
docker container logs <container_id_or_name>

# Stats
docker container stats <container_id_or_name>

# Processes (processes in docker also shows in host machine i.e. it uses host machine kernal)
ps -aux
docker container top <container_id_or_name>

# Port forwarding 
Check opened ports (netstat -nltp or netstat -tuln)
docker container run -p <host_port>:<container_port> <image>
docker container run -P <image>

# Check port 
docker container port <container_id_or_name>

# Interact with deattached container, container must be created with -dit command
docker container exec -it <container_id_or_name> /bin/bash
docker container exec -it <container_id_or_name> /bin/bash -c "cat /etc/os-release"

# Attach (connects to a running container's standard input, output, & error streams)
docker attach <container_id_or_name>

# Wait - returns the exit code when stopped
docker container wait <container_id_or_name>
docker container stop <container_id_or_name>

# Changes made to a container's filesystem 
# A: A file or directory was added.
# C: A file or directory was changed.
# D: A file or directory was deleted.
docker container diff <container_id_or_name>
watch "docker container diff <container_id_or_name>"

# Copy from host to the container
docker container cp <path_on_host> <container_id_or_name>:<path_in_container>

# Copy from container to the host
docker container cp <container_id_or_name>:<path_in_container> <path_on_host>

# Export 
# Creating a backup of a running or stopped container, including its current state and files, but not its image layers, history or metadata
# Use docker export when you need to capture the state of a specific container's filesystem
docker container export <container_id_or_name> -o project_image.tar
docker container export <container_id_or_name> > project_image.tar

# Import
docker image import <exported_tarball_name> <new_image_name>
docker image import project_image.tar project_image

# Build an image from container
docker container commit <container_id_or_name> <new_image_name> 
docker container commit --author "Mohsin" -m "Test commit" <container_id_or_name> <new_image_name> 

# Pushing image to Docker hub
docker image tag <image_name> <docker_hub_registry>/<docker_hub_name>/<image_name>
docker image tag project_image hub.docker.com/mohsin0582/project_image
docker image tag project_image mohsin0582/project_image
docker push mohsin0582/project_image


=============================================================================================
Image commands
=============================================================================================
# List all images
docker images
docker image ls
docker image ls --format '{{.ID}} , {{.Repository}} - {{.Tag}}'

# History
docker image history <image_name>
docker image history ubuntu

# Inspect
docker image inspect <image_name> | less

# Remove
docker image rm <image_name>
docker image rm -f <image_name>
docker image prune
docker image prune -f
docker rmi <image_name>

# Save
# Saves one or more Docker images and all its layers, metadata, and tags
# Use docker save when you want to transfer or back up Docker images.
docker image save <image_name> > project_image.tar     
docker image save project_image > project_image.tar
docker save -o <image_name> project_image.tar
docker save -o my_image.tar my_image:tag

# Load
docker image load < <image_name>
docker image load < project_image.tar


=============================================================================================
Volume commands
=============================================================================================
# Volume persists if container is removed

# List all volumes
docker volume ls

# Anonymous volume is created & mounted to a container directory
docker run -v /path/in/container <image_name>
docker run -v /var/lib/mysql <image_name>

# Named volume (if volume doesn't exists, Docker will automatically create it)
docker volume create <volume_name>
docker run -v <volume_name>:/path/in/container <image_name>
docker run -v <volume_name>:/var/lib/mysql <image_name>

# Inspect
# /var/lib/mysql is the container volume mountpoint in mysql img
docker image inspect <image_name> | less
# Check mountpoint for viewing data inside container
docker volume inspect <volume_id_or_name>

# Attach volume
docker run -v <volume_id_or_name>:/path/in/container <image_name>
docker run -v <volume_id_or_name>:/var/lib/mysql <image_name>

# Bind mount (using host machine folder in container)
# Always use absolute path
# If there is some data in /path/in/container it will hide
docker container run -v /path/on/host:/path/in/container <image_name>
docker container run -v $(pwd):/path/in/container <image_name>
docker container run --mount type=bind,source=/path/on/host,target=/path/in/container <image_name>

# Remove all unused volumes
docker volume prune -f


=============================================================================================
Network commands
=============================================================================================
# 2 containers in the same network can communicate with each other
# Already created networks bridge, host and null
# Create a seperate network for each application e.g. mysql, tomcat
# Default bridge network in Docker doesn't has DNS enabled (means we cannot ping containers based on hostname) 
# Custom network has DNS enabled by default (means we can ping containers based on hostname) 
# To make sure our default network has DNS enabled, delete and recreate the network with name "bridge" and driver "bridge" (docker network create -d bridge bridge)
# You can have only one host driver network
# Host network has same network settings as host machine (when you create a container every namespace is created new in isolation except network in Host network case)
# You can have only one none driver network
# None network is used when you don't want to allocate any network to a container
# You cannot connect a container that is already running on a bridge network directly to the host network
# You cannot connect a container that is already running on a bridge network directly to the none network

# List all networks
docker network ls

# Inspect
# Default network is bridge
# Inspect bridge and check containers if there is no container, create a container and check
docker network inspect bridge

# Create
docker network create -d bridge <network_name>

# Attach network
docker container run -it --network <network_name> <image_name>
docker container run -it --network bridge <image_name>
docker container run -it --network host <image_name>
docker container run -it --network none <image_name>

# Subnet
docker network create --subnet=192.168.1.0/24 my_custom_network

# Connect (connect container1 network1 to container2 network2)
docker network connect <network_name> <container_name> 
docker network connect network2 container1

# Disconnect (connect container1 network1 to container2 network2)
docker network disconnect <network_name> <container_name> 

# Remove all unused networks
docker network prune -f


=============================================================================================
Clean up commands
=============================================================================================
# Remove stopped/unused containers (-f without being prompted for confirmation)
docker container prune -f

# Remove all containers (stop and remove)
docker stop $(docker ps -aq) && docker rm -f $(docker ps -aq)
docker rm -f $(docker kill $(docker ps -aq))
docker container rm -f $(docker container ls -aq) 

# Delete all containers with volumes:
docker rm -vf $(docker ps -aq)

# Remove all images which are not in use containers , add -a
docker image prune -a

# Delete all images:
docker rmi -f $(docker images -aq)

# Remove all unused volumes
docker volume prune -f

# Remove all unused networks
docker network prune -f

# Delete all unused data (i.e., in order: containers stopped, volumes without containers and images with no containers)
docker system prune -a --volumes -f