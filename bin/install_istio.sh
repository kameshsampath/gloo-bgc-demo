#!/bin/bash

set -eu
set -o pipefail 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "$SCRIPT_DIR/currentEnv.sh"

source "$SCRIPT_DIR/helpers.sh"

export KUBECONFIG=$TUTORIAL_HOME/work/.kube/config

if [ -z "$1" ];
then 
  echo "Please pass the cluster context"
  exit 1
fi

# Operator install
printf "\n Installing Istio on cluster '%s' \n" "${1}"

kubectl  --context="${1}" create ns istio-operator || true
istioctl --context="${1}" operator init 

kubectl --context="${1}" rollout status deploy/istio-operator -n istio-operator --timeout=120s

envsubst < "$TUTORIAL_HOME/cluster/istio/istio-cr.yaml" | kubectl --context "${1}" apply -f -

printf "Waiting for the Istio Deployments to be created...\n"

sleep 10

kubectl --context="${1}" rollout status deploy/istiod -n istio-system --timeout=120s
kubectl --context="${1}" rollout status deploy/istio-ingressgateway -n istio-system --timeout=120s

exit 0;