=============================================================================================
Notes
=============================================================================================
If both the Dockerfile and the docker-compose.yml file specify images for the same service, the image in the docker-compose.yml will take precedence.

If you use both build and image in your docker-compose.yml, Docker will build the image using the Dockerfile and tag it with the specified image name.

Docker compose automatically finds .env file and load it's variable values in docker compose file


=============================================================================================
Installing wordpress & MySQL from adhoc-commands
=============================================================================================
docker container run -d --name con_mysql -e MYSQL_ROOT_PASSWORD=OkayOkay8 mysql
docker container inspect con_mysql

# Give IP address of the DB container to WORDPRESS_DB_HOST
docker container run -d --name con_wordpress -e WORDPRESS_DB_HOST=172.17.0.2:3306 -e WORDPRESS_DB_USER=root -e WORDPRESS_DB_PASSWORD=OkayOkay8 wordpress

docker container inspect con_wordpress

# Hit Wordpress container IP address
http://localhost:8080


=============================================================================================
Docker compose Installing wordpress & MySQL
=============================================================================================
services:
  wordpress:
    image: wordpress:latest
    ports:
      - "8080:80"  # Map port 8080 on the host to port 80 on the container
    environment:
      WORDPRESS_DB_HOST: db:3306  # The hostname of the MySQL database service
      WORDPRESS_DB_USER: example_user
      WORDPRESS_DB_PASSWORD: example_password
      WORDPRESS_DB_NAME: example_db
    depends_on:
      - db  # Ensure db service is started before wordpress

  db:
    image: mysql:5.7  # Use MySQL version 5.7
    environment:
      MYSQL_ROOT_PASSWORD: root_password  # Root password for MySQL
      MYSQL_DATABASE: example_db  # Database name
      MYSQL_USER: example_user  # User to connect to the database
      MYSQL_PASSWORD: example_password  # User password
    volumes:
      - db_data:/var/lib/mysql  # Persist MySQL data

volumes:
  db_data:  # Named volume for MySQL data persistence


=============================================================================================
Docker compose commands
=============================================================================================
# Create, start & run containers, volumes & networks in detached mode
docker compose up -d

# Creating containers without starting
docker compose up --no-start

# Deletes everything except volumes
docker compose down

# Deletes everything including volumes
docker compose down --volumes (or docker compose down -v)

# It creates containers only, no network created
docker compose create

# Start containers, no network started
docker compose start

# Stop containers
docker compose stop

# Delete containers, no network removed
docker compose rm

# List the containers defined in docker compose.yml file & their current state
docker compose ps -a

# List only the services (not individual containers)
docker compose ps --services

# Forcibly stop running containers
docker compose kill
docker compose kill <service_name>

# Display the mapped port for a specific service
docker compose port <service> <port>
docker compose port web 80

# View the logs of the services in real time
docker compose logs -f

# Execute a command in a running container
docker compose exec <service_name> <command>
docker compose exec wordpress sh
docker compose exec db mysql -u root -p

# Execute a command in a running container with specific user
docker compose exec --user mohsin web bash

# Creates a new container from the specified service and starts it
docker compose run <service_name> [command]
docker compose run wordpress bash

# Automatically remove the new created container after it exits
docker compose run --rm wordpress bash

# Restart services
docker compose restart <service_name_1> <service_name_2>

# Wait for 30 seconds before killing the container if it doesn’t stop gracefully
docker compose restart -t 30

# Pull images
docker compose pull

# Continue pulling other images even if some fail
# --parallel: By default, images are pulled sequentially
docker compose pull --ignore-pull-failures

# Scale a specific service
docker compose scale <service_name_1>=<number> <service_name_2>=<number>
docker compose scale web=3 db=2

# Display the running processes of the containers 
docker compose top