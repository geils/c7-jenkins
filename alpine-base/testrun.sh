#!/bin/bash

set -x
echo -e "### REMOVE VOLUME $1"
docker volume rm $1

echo -e "### CREATE VOLUME $1"
docker volume create $1

echo -e "### RUN DOCKER IMAGE $1"
docker run -d --name $1 --privileged -e "JAVA_OPTS=-Xmx1024m -Djenkins.install.runSetupWizard=false" -p :22 -p 8080:8080 -p 50000:50000 -v $1:/var/lib/jenkins $1
