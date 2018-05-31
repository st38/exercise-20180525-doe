# Read variables
source variables.txt

# Activate connection to remote docker instance
eval $(docker-machine env --shell /bin/bash nginx)

# Get latest container
echo Get latest container
docker pull "${creator}"/"${container}":latest

# Verify if container already running
status="$(docker ps --filter name=${container} --filter status=running --quiet)"

if [ -n "${status}" ]; then
  echo Container "${container}" is ruuning and should be stopped before deploy

  # Stop running container
  echo Stopping "${container}" container
  docker stop "${container}"

else
  echo Container is not running and no need to be stopped
fi

# Remove old container
echo Remove old "${container}" container
docker rm "${container}"

# Run new container
echo Run new "${creator}"/"${container}" container
docker run --name "${container}" -p 80:8888 -d "${creator}"/"${container}":latest