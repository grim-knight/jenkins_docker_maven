#!/bin/bash

echo maven-project > /tmp/.auth
echo $BUILD_TAG >> /tmp/.auth
echo $PASS >> /tmp/.auth

scp -i /opt/prod /tmp/.auth dev-user@ip-172-31-84-120:/tmp/.auth
scp -i /opt/prod ./jenkins/deploy/publish dev-user@ip-172-31-84-120:/tmp/publish
ssh -i /opt/prod dev-user@ip-172-31-84-120 "/tmp/publish"
