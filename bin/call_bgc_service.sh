#!/bin/bash

set -eu
set -o pipefail

trap '{ echo "" ; exit 1; }' INT

SVC_URL=$(kubectl --context "$1" -n istio-system get svc istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].*}')

printf "Polling Service URL %s/api" "$SVC_URL"

http --body "$SVC_URL/api"

