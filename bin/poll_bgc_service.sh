#!/bin/bash

set -eu
set -o pipefail

trap '{ echo "" ; exit 1; }' INT

if [ ! -f "$TUTORIAL_HOME/$1.url" ];
then
 kubectl --context "$1" -n istio-system get svc istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].*}' | tee "$TUTORIAL_HOME/$1.url"
fi
SVC_URL=$(cat "$TUTORIAL_HOME/$1.url")

printf "\n###################################################\n"
printf "\nPolling Service URL %s/api \n" "$SVC_URL"
printf "\n###################################################\n"

while true
do 
  http --body "$SVC_URL/api"
  echo
  sleep .3;
done

