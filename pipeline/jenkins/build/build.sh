#!/bin/bash

# Copy the new jar to the build location
echo "I'm in directory - $PWD"
cp -f pipeline/java-app/target/*.jar pipeline/jenkins/build/

echo "****************************"
echo "** Building Docker Image ***"
echo "****************************"
#building the aoolication with the jar.
echo "I'm in directory - $PWD"
cd pipeline/jenkins/build/ && docker-compose -f docker-compose-build.yml build --no-cache
