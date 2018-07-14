#!/bin/bash
set -e

source /opt/resource/common.sh

docker login $HARBOR_URL -u $HARBOR_USERNAME -p $HARBOR_PASSWORD
docker pull $HARBOR_IMAGE
docker images
docker push $HARBOR_IMAGE 2>/dev/null
