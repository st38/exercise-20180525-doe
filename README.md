# Exercise - DOE

 1. [Goals](#goals)
 2. [Prerequisites](#prerequisites)
 3. [Requirements](#requirements)
 4. [Duration](#duration)
 5. [Prepare environment](#prepare-environment)
 6. [Verification](#verification)
 7. [Clean environment](#clean-environment)
 8. [Known issues](#known-issues)


# Goals

 1. Create Docker container with Nginx server with GitHub webhook deployment triggering using Jenkins pipelines (Jenkinsfile).


## Prerequisites

 1. Linux OS with installed Jenkins and installed plugins.
 2. GitHub reposotory with scripts and custom nginx index and configuration files.


## Requirements

 1. Linux OS with [Docker](https://docs.docker.com/install/) and [Docker Machine](https://docs.docker.com/machine/install-machine/) installed.
 2. AWS account with AmazonEC2FullAccess permissions.
 3. GitHub account.
 4. Docker Hub account.


## Duration

 Task can be accomplished in for about 30 minutes.


## Prepare environment

 1. Configure AWS credentials for Docker Machine on local Linux:
	```
	mkdir ~/.aws
	vi ~/.aws/credentials
	```
	
	```bash
	[default]
	aws_access_key_id = access_key_id
	aws_secret_access_key = secret_access_key
	```

 2. Provision Dockerized AWS EC2 instance for Jenkins container:
	```bash
	region="eu-central-1"
	name="jenkins"
	port="80"
	
	docker-machine create --driver amazonec2 --amazonec2-open-port "${port}" --amazonec2-region "${region}" "${name}"
	```

 3. Make connection to jenkins inctance as active:
	```bash
	eval $(docker-machine env jenkins)
	```

 4. Get scripts from GitHub:
	```bash
	github_username="st38"
	repository_name="exercise-20180525-doe"
	
	git clone https://github.com/"${github_username}"/"${repository_name}".git
	```

 5. Build custom Jenkins container:
	```bash
	docker build -t "jenkins-custom:latest" -f ${repository_name}/jenkins/Dockerfile .
	```

 6. Run created docker container on jenkins EC2 instance
	```bash
	docker run --name jenkins-custom -p 80:8080 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -d jenkins-custom:latest
	```

 7. Get jenkins EC2 instance IP:
	```bash
	docker-machine ip jenkins
	```

 8. Get Jenkyns initialAdminPassword:
	```bash
	docker exec jenkins-custom cat /var/jenkins_home/secrets/initialAdminPassword
	```

 9. Log in to Jenkins using http://{jenkins ip}, configure [GitHub credentials and server](https://www.mirantis.com/blog/intro-to-cicd-how-to-make-jenkins-build-on-github-changes/) and then add *New Item*:
    * Name: nginx-lua --> Multibranch Pipeline --> Ok
        * Branch Sources: GitHub
        * Credentials
            * Owner: st38
            * Repository: exercise-20180525-doe
            * Behaviors --> Filter by name (with wildcards) --> Include: master  

        --> Save

10. Configure AWS credentials for Docker Machine inside the jenkins-custom container:
	```bash
	jenkins_home="/var/jenkins_home"
	
	docker exec -it jenkins-custom mkdir "${jenkins_home}"/.aws
	docker cp ~/.aws/credentials jenkins-custom:"${jenkins_home}"/.aws
	```

11. Provision Dockerized AWS EC2 instance for Nginx container:
	```bash
	region="eu-central-1"
	name="nginx"
	port="80"
	
	docker exec -it jenkins-custom docker-machine create --driver amazonec2 --amazonec2-open-port "${port}" --amazonec2-region "${region}" "${name}"
	```
	

12. Log in to jenkins-custom container
	```bash
	docker exec -it jenkins-custom bash
	```

13. Make connection to the nginx instance as active
	```
	eval $(docker-machine env --shell /bin/bash nginx)
	```

14. Configure credentials for Docker Hub:
	```bash
	docker login
	
	Username: st38
	Password: ****
	
	exit
	```

> **Note**: Changes on repository side must be done after Jenkins server IP is changed: Repository --> Settings --> Webhooks


## Verification

 1. Get nginx-lua instance IP:
	```bash
	docker exec -it jenkins-custom docker-machine ip nginx
	```

 2. Create a `test` branch from a `master` and change nginx/index.html file.

 3. Change nginx/index.html in the `master` branch.

 4. Changes can be seen on:
    * http://${nginx ip}/
    * http://${nginx ip}/hello-lua


## Clean environment

 1. Remove instances in Amazon EC2:
	```bash
	# Log in to jenkins-custom container
	docker exec -it jenkins-custom bash
	
	# Make connection to the nginx instance as active
	eval $(docker-machine env --shell /bin/bash nginx)
	
	# Remove nginx instance
	docker-machine rm --force nginx
	
	# Exit from jenkins-custom container
	exit
	
	# Make connection to the jenkins instance as active
	eval $(docker-machine env jenkins)
	
	# Remove jenkins instance
	docker-machine rm --force jenkins
	
	# Log out from jeknins remote instance and make local connection as active
	eval $(docker-machine env -u)
	```

 2. [Delete Docker repository on Docker Hub](https://success.docker.com/article/how-do-i-delete-a-repository).

 3. Remove security group created bu Docker Machine from AWS account.

 4. Remove data downloaded from GitHub:
	```bash
	rm -rf "${repository_name}"
	```

## Known issues

 1. Some time docker-machine can't provision an instance but create certificate and keypair on EC2. In order to reuse same instance name a directory `~/.docker/machine` and an apropriate keypair on AWS EC2 should be removed.