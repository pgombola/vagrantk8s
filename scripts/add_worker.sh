#!/bin/bash

set -eou pipefail
IFS=$'\n\t'

# TODO: function to parse from vagrantfile
subnet="172.17.8"

if [ -z ${WORKERS:-} ]; then
  echo "please set WORKERS environment variable first"
  exit 1
fi

HOST="worker-$(($WORKERS+1))"
NET="$subnet.$((100+$WORKERS+1))"

echo "Current worker count: $WORKERS"
echo "Adding node: $HOST/$NET"

echo "Launching new host"
export WORKERS=$(($WORKERS+1))
vagrant up "$HOST" &> /dev/null
echo "Finished launching new host"

echo "Updating /etc/hosts on current hosts"
vagrant ssh master -c "echo '$NET $HOST' | sudo tee -a /etc/hosts" &> /dev/null
for i in $(seq 1 $WORKERS); do
  vagrant ssh worker-$i -c "echo '$NET $HOST' | sudo tee -a /etc/hosts" &> /dev/null
done
echo "Finished updating /etc/hosts"

echo "Update current shell with: export WORKERS=$WORKERS"
