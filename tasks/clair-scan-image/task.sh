#!/bin/bash
set -e

# Install klar
sed -i -e 's/us.archive.ubuntu.com/archive.ubuntu.com/g' /etc/apt/sources.list
apt-get -y update
apt-get -y install curl

#curl -L https://raw.githubusercontent.com/jgsqware/clairctl/master/install.sh | sh
mkdir -p /usr/local/bin
curl -L https://github.com/optiopay/klar/releases/download/v1.5/klar-1.5-linux-amd64 -o /usr/local/bin/klar && chmod +x $_

export CLAIR_IMAGE 
export CLAIR_ADDR=http://ns1.tcs-ally.tk:6060

# Scan the image

export HIGH=$(REGISTRY_INSECURE=true $CLAIR_ADDR klar $VCLAIR_IMAGE | tail -n 7 | grep High | awk '{print$2}')

if [[ $HIGH -lt 1 ]]; then
  echo "+++Image $CLAIR_IMAGE has passed scan threshold+++"
else
  echo "---Image $CLAIR_IMAGE has failed scan threshold+++"
  exit 1
fi
