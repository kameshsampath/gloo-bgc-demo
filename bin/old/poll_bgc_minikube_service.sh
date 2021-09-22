#!/bin/bash

set -eu
set -o pipefail

trap '{ echo "" ; exit 1; }' INT

URL=$(minikube -p istio-mk ip):$(kubectl get service/blue-green-canary -o jsonpath="{.spec.ports[*].nodePort}")/hello

echo "$URL"

while true
do 
  curl $URL
  echo
  sleep .3;
done

