#!/bin/bash

echo "********************"
echo "** Pushing image ***"
echo "********************"

IMAGE="maven-project"

echo "** Logging in ***"
docker login -u msvvsagarreddy -p $PASS
echo "*** Tagging image ***"
docker tag $IMAGE:$BUILD_TAG msvvsagarreddy/$IMAGE:$BUILD_TAG
echo "*** Pushing image ***"
docker push msvvsagarreddy/$IMAGE:$BUILD_TAG

