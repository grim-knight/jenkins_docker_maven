#!/bin/bash

echo docker-jenkins-maven-project > /tmp/.auth
echo $BUILD_TAG >> /tmp/.auth
echo $PASS >> /tmp/.auth

scp -i /opt/prod /tmp/.auth ec2-user@ip-10-1-29-165:/tmp/.auth
scp -i /opt/prod ./jenkins/deploy/publish ec2-user@ip-10-1-29-165:/tmp/publish
ssh -i /opt/prod ec2-user@ip-10-1-29-165 "/tmp/publish"
