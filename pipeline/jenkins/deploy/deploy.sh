#!/bin/bash

echo docker-jenkins-maven-project > /tmp/.auth
echo $BUILD_TAG >> /tmp/.auth
echo $PASS >> /tmp/.auth

rsync -avz -e "ssh -i /home/ec2-user/jenkins/jenkins_docker_maven/tf/prod" /tmp/.auth ec2-user@3.93.177.29:/tmp/
rsync -avz -e "ssh -i /home/ec2-user/jenkins/jenkins_docker_maven/tf/prod" /home/ec2-user/jenkins/jenkins_docker_maven/pipeline/jenkins/deploy/publish ec2-user@3.93.177.29:/tmp/publish
rsync -avz -e "ssh -i /home/ec2-user/jenkins/jenkins_docker_maven/tf/prod" ec2-user@3.93.177.29 "/tmp/publish"
