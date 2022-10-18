#!/bin/bash

# aws account number
ACCOUNT=$(aws sts get-caller-identity --query 'Account' --output text)

# aws ECR region
REGION=us-west-2

# Kubernetes secret name
SECRET_NAME=${REGION}-ecr-registry

# Get real email
EMAIL=`grep email ~/.gitconfig | cut -d= -f2 | xargs`

# Get AWS Token
TOKEN=`aws ecr --region=$REGION get-authorization-token --output text --query authorizationData | cut -f1 | base64 -d | cut -d: -f2`

kubectl delete secret --ignore-not-found $SECRET_NAME
kubectl create secret docker-registry $SECRET_NAME \
 --docker-server=https://$ACCOUNT.dkr.ecr.${REGION}.amazonaws.com \
 --docker-username=AWS \
 --docker-password="${TOKEN}" \
 --docker-email="${EMAIL}"
