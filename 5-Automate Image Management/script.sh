#!/bin/bash

IMAGE_NAME="nginx"
PRIVATE_REGISTRY="localhost:5000/$IMAGE_NAME"

# Check if image exists in the private registry
# /dev/null is a special file in Unix-like operating systems that discards all data written to it, use case when you want to run a command but don’t want to see its output
if ! curl --silent --fail "http://localhost:5000/v2/$IMAGE_NAME/manifests/latest" > /dev/null; then
    echo "Image not found in private registry, pulling from Docker Hub..."
    docker pull $IMAGE_NAME
    docker tag $IMAGE_NAME $PRIVATE_REGISTRY
    docker push $PRIVATE_REGISTRY
else
    echo "Image found in private registry, pulling from there..."
fi
