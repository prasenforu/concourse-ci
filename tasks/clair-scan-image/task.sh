#!/bin/bash
set -e

# Install klar
sed -i -e 's/us.archive.ubuntu.com/archive.ubuntu.com/g' /etc/apt/sources.list
apt-get -y update
apt-get -y install curl

mkdir -p /usr/local/bin
curl -L https://github.com/optiopay/klar/releases/download/v1.5/klar-1.5-linux-amd64 -o /usr/local/bin/klar && chmod +x $_

export CLAIR_IMAGE 
#export CLAIR_HOST=http://10.90.1.78:6060
export CLAIR_ADDR
echo $CLAIR_ADDR
echo $CLAIR_IMAGE
echo $CLAIR_HOST

# Scan the image

#export HIGH=$(REGISTRY_INSECURE=true http://10.90.1.78:6060 /usr/local/bin/klar $CLAIR_IMAGE | tail -n 7 | grep High | awk '{print$2}')
export HIGH=$(REGISTRY_INSECURE=true CLAIR_ADDR=$CLAIR_HOST /usr/local/bin/klar $CLAIR_IMAGE | tail -n 7 | grep High | awk '{print$2}')
echo $HIGH

if [[ $HIGH -lt 1 ]]; then
  echo "+++Image $CLAIR_IMAGE has passed scan threshold+++"
else
  echo "---Image $CLAIR_IMAGE has failed scan threshold+++"
  exit 1
fi
