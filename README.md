# Pixelfed Dockerized

Pixelfed Dockerized is a dockerized version of the pixelfed installation.

This project is not related to the development of Pixelfed. HOwever, the goal is to provide a fully dockerized and easy to setup container version of the pixelfed server. 

This project does not container any of the original Pixelfed code/project, rather is doing all the installation in containers when being fired the very first time. 

All code/scripts are "as is" and are currently in the most pre-release and unstable state you might think of. 

# Run & Setup 

Run `docker-compose up' to start up all required containers. 
The installation of pixelfed will be performed during the initial run of the containers. 

# Containers

The project contains the following containers: 

## php-fdm-pixelfed
## nginx-pixelfed
## redis-pixelfed
## mariadb

# Build & Publish 

Skripts are availabel at: 

```
./scripts/build.sh 
./scripts/publish.sh
```

Both scripts are tested and executed using Ubuntu 22.04. 










