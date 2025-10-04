#!/bin/bash
set -e

# Variables
REPO_URI="235494814246.dkr.ecr.ap-southeast-7.amazonaws.com/notgub-website-repo"
IMAGE_NAME="notgub-website"
TAG="latest"

echo "Building Docker image..."
docker build -t $IMAGE_NAME .

echo "Tagging image for ECR..."
docker tag $IMAGE_NAME:latest $REPO_URI:$TAG

echo "Pushing image to ECR..."
docker push $REPO_URI:$TAG

echo "✅ Image pushed successfully: $REPO_URI:$TAG"