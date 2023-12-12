#!/bin/sh
ACCOUNT_ID="979490057625"
AWS_DEFAULT_REGION="us-east-1"
REPOSITORY_URI="$ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com"
IMAGE_REPO_NAME="demo-nginx"
docker pull nginx:latest
aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $REPOSITORY_URI 
docker tag nginx:latest $REPOSITORY_URI/$IMAGE_REPO_NAME:latest
docker push $REPOSITORY_URI/$IMAGE_REPO_NAME:latest
