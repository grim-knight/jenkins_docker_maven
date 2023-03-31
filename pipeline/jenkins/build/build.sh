#!/bin/bash

# Copy the new jar to the build location
echo "I'm in directory - $PWD"
cp -f java-app/target/*.jar jenkins/build/

echo "****************************"
echo "** Building Docker Image ***"
echo "****************************"
#building the aoolication with the jar.
cd jenkins/build/ && docker-compose -f docker-compose-build.yml build --no-cache
