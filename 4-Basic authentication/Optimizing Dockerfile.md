=============================================================================================
Basic authentication
=============================================================================================
mkdir auth
docker container run --entrypoint htpasswd registry -bnB mohsin OkayOkay8 >auth/htpasswd
cat auth/htpasswd

docker container run -d \
 -p 5000:5000 \
 --name registy_ \
 -v "$(pwd)"/auth:auth \
 -v "$(pwd)"/certs:certs \
 -e "REGISTRY_AUTH=htpassowrd" \
 -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
 -e "REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd" \
 -e "REGISTRY_AUTH_TLS_CERTIFICATE=/certs/domain.cert" \
 -e "REGISTRY_AUTH_TLS_KEY=/certs/domain.key" \
registry

docker login repo.docker.local:5000
docker image push repo.docker.local:5000/nginx