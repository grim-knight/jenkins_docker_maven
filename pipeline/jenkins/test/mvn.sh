#!/bin/bash

echo "***************************"
echo "** Testing the code ***********"
echo "***************************"

WORKSPACE=WORKSPACE=/home/ec2-user/jenkins/jenkins_home/workspace/Demo-pipeline

docker run --rm  -v  $WORKSPACE/java-app:/app -v /root/.m2/:/root/.m2/ -w /app maven "$@"
