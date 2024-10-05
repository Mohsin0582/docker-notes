=============================================================================================
Notes
=============================================================================================
# Standard is to use Capital words but you can use small
# use Dockerfile for dockerizing
# every layer runs on different container (after changing directory it will still show root directory)
    RUN pwd > /tmp/1.txt
    RUN cd /tmp/
    RUN pwd > /tmp/2.txt


=============================================================================================
Dockerfile commands
=============================================================================================
# Build image from Dockerfile
docker image build -t ubuntu .


=============================================================================================
Docker file
=============================================================================================
FROM ubuntu
RUN apt-get update && apt-get install -y openssh-server

# Label (add metadata to an image)
LABEL name="Mohsin"
LABEL maintainer="yourname@example.com" \
      version="1.0" \
      description="This is a sample Docker image for demonstration."

# Environment variable
ENV NAME mohsin
ENV PASS password

# Working directory
WORKDIR /tmp
 
# Expose a port (22 for ssh)
EXPOSE 22

# Create 1.txt as root user & 2.txt as mohsin user
RUN useradd -d /home/mohsin -g root _G sudo -m -p $(echo "$PASS" | openssl passwd -1 -stdin) $NAME
RUN whoami > /tmp/1.txt
USER $NAME
RUN whoami > /tmp/2.txt

# Copy folder contents from host machine to container
# COPY and ADD commands both can be used
# COPY command (copies files and directories)
# ADD command (copies files and directories, automatically extract compressed files, dupport remote URLs)
RUN mkdir -p /tmp/project
COPY testproject /tmp/project
ADD testproject /tmp/project


# ENTRYPOINT command runs when a container is started from the image
# The command specified in ENTRYPOINT will always run. This means that if the command exits, the container stops.
# CMD can provide default arguments to the ENTRYPOINT command
# It will execute python3 /app/script.py --help
    Exec form (recommended):
    ENTRYPOINT ["executable", "param1", "param2"]
    
    Shell form:
    ENTRYPOINT command param1 param2

# ENTRYPOINT Example 1:
ENTRYPOINT ["python3", "/app/script.py"]
CMD ["--help"]

# ENTRYPOINT Example 2:
demo.sh
echo "My name is $1"

COPY demo.sh /tmp
ENTRYPOINT ["/tmp/test.sh"]
CMD ["mohsin"]

# Overriding ENTRYPOINT:
    # Executes: /bin/bash
    docker run --entrypoint /bin/bash myimage



# You can only have one CMD instruction in a Dockerfile
# CMD is the default command to run when a container is started from the image
    Exec form (recommended):
    CMD ["echo", "Hello, World!"]
    CMD ["sh", "-c", "echo 'Hello, World!' && curl -s https://api.example.com/data | jq '.'"]
    CMD ["sh", "-c", "/usr/local/bin/myscript.sh"]
    
    Shell form:
    CMD echo "Hello, World!"
    CMD echo "Hello, World!" && curl -s https://api.example.com/data | jq '.'
    CMD sh -c "/usr/local/bin/myscript.sh"

# Overriding CMD:
    # Executes: python3 /app/script.py --version
    docker run <image_name> --version


# Keep the container running
CMD ["/usr/sbin/sshd", "-D"]


# SSH into container (use 2nd terminal), not a part of Dockerfile
docker container inspect <container_id_or_name>
ssh mohsin@172.17.0.2

# SSH into container with port (use 2nd terminal), not a part of Dockerfile
docker container run -itd -P --name ssh_server_container ubuntu
docker container ls
ssh mohsin@172.17.0.2 -p 32788