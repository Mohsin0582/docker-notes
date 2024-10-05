=============================================================================================
Create private registry
=============================================================================================
# Use registry image to create a private registry
# Default port of registry image is 5000
docker container run -d -p 5000:5000 --name <container_name> <image_name>
docker container run -d -p 5000:5000 --name private_registry registry

# Check images in your private registry 
http://127.0.01:5000/v2/_catalog

# By default a volume is created and attached to the registry 
# Check Destination in Mounts
# Check Driver in Mounts (you can use different drivers e.g. S3, openshift etc)
docker container inspect <container_name>
docker container inspect private_registry

# Push image to your private registry
# By default docker allows only secure network & ip of ranges 127.0.0.0/8
docker image tag ubuntu 127.0.0.1:5000/ubuntu
docker image push 127.0.0.1:5000/ubuntu

# Pull image from your private registry
docker image pull 127.0.0.1:5000/ubuntu


=============================================================================================
Insecure private registry
=============================================================================================
# Insecure private registry (for docker desktop paste the daemon.json code in ⚙️ > Docker Engine )
docker image tag nginx 10.0.2.15:5000/nginx
touch daemon.json
mv daemon.json /etc/docker/
service docker restart
docker container start <container_name>
docker image push 10.0.2.15:5000/nginx


=============================================================================================
Secure private registry
=============================================================================================
mkdir certs
# Generate SSL, create a common name (e.g. repo.docker.local)
openssl req -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key -x509 -days 365 -out certs/domain.cert

cd /etc/docker
mkdir certs.d
cd certs.d
mkdir repo.docker.local:5000 
cp certs/domain.cert /etc/docker/repo.docker.local\:5000/ca.crt
service docker restart

docker container run -d -p 5000:5000 --name secure_registry -v $(pwd)/certs/"/certs - e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.cert -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key registry

ifconfig
cat /etc/hosts
10.0.2.15 repo.docker.local

docker image tag nginx repo.docker.local:5000/nginx
docker image push repo.docker.local:5000/nginx

