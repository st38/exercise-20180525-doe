#!/bin/bash

source variables.txt

# Push container to Docker Hub
echo Push "${creator}"/"${container}" container to Docker Hub
docker push "${creator}"/"${container}"