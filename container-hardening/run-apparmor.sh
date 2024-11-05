#!/bin/bash

docker run \
  --publish 8080:8080 \
  --name chard \
  --memory="64m" \
  --memory-swap="64m" \
  --cpus="0.01" \
  --restart="always" \
  --read-only \
  --detach \
  --security-opt apparmor:docker-chard-sample \
  --cap-drop ALL \
  chard:local

while true; do
  curl -s localhost:8080/echo > /dev/null
done

