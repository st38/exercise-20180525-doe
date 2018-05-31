#!/bin/bash

source variables.txt

latest="$(echo `date +%Y%m%d-%H%M%S`)"
echo $'\n'latest="${latest}" >>variables.txt

# Log in to local docker before build
echo Log in to local docker before build
eval $(docker-machine env -u --shell /bin/bash)

# Build docker container
echo Build "${creator}/${container}:latest" docker container
docker build -t "${creator}/${container}:latest" -t "${creator}/${container}:${latest}" -f nginx/Dockerfile .