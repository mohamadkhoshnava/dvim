#!/bin/bash

# Configuration
IMAGE_NAME="dvim"
DOCKER_HUB_USER="seyeddev"
TAG="latest"

FULL_IMAGE_NAME="$DOCKER_HUB_USER/$IMAGE_NAME:$TAG"

echo "Building image: $FULL_IMAGE_NAME"
docker build -t $FULL_IMAGE_NAME .

echo "Pushing instructions:"
echo "1. Ensure you are logged in: 'docker login'"
echo "2. Push the image: 'docker push $FULL_IMAGE_NAME'"

read -p "Do you want to push now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker push $FULL_IMAGE_NAME
    echo "Successfully pushed to Docker Hub!"
else
    echo "Skipped push."
fi
