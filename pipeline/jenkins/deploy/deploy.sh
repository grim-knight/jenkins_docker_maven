#!/bin/bash

echo docker-jenkins-maven-project > /tmp/.auth
echo $BUILD_TAG >> /tmp/.auth
echo $PASS >> /tmp/.auth

rsync -avz -e "ssh -i /opt/prod" /tmp/.auth ec2-user@3.93.177.29:/tmp/
echo "i got executed"
echo "$PWD"
rsync -avz -e "ssh -i /opt/prod" ./pipeline/jenkins/deploy/publish ec2-user@3.93.177.29:/tmp/publish
echo "i got executed"
ssh -i /opt/prod ec2-user@3.93.177.29 "/tmp/publish"
echo "Finally success"
