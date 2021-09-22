#!/bin/bash

set -eu
set -o pipefail 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "$SCRIPT_DIR/currentEnv.sh"

source "$SCRIPT_DIR/helpers.sh"

export KUBECONFIG=$TUTORIAL_HOME/work/.kube/config

# Operator install
printf "\n Installing Istio on cluster '%s' \n" "${CLUSTER1}"

kubectl  --context="${CLUSTER1}" create ns istio-operator || true
istioctl --context="${CLUSTER1}" operator init 

kubectl --context="${CLUSTER1}" rollout status deploy/istio-operator -n istio-operator --timeout=120s

envsubst < "$TUTORIAL_HOME/cluster/istio/istio-cr.yaml" | kubectl --context "${CLUSTER1}" apply -f -

# kubectl --context="${CLUSTER1}" rollout status deploy/istiod -n istio-system --timeout=120s
# kubectl --context="${CLUSTER1}" rollout status deploy/istio-ingressgateway -n istio-system --timeout=120s

printf  "\n Installing Istio on cluster '%s' \n" "${CLUSTER2}"

kubectl --context="${CLUSTER2}" create ns istio-operator || true
istioctl --context="${CLUSTER2}" operator init 

kubectl --context="${CLUSTER2}" rollout status deploy/istio-operator -n istio-operator --timeout=120s

envsubst < "$TUTORIAL_HOME/cluster/istio/istio-cr.yaml" | kubectl --context "${CLUSTER2}" apply -f -

# kubectl --context="${CLUSTER2}" rollout status deploy/istiod -n istio-system --timeout=120s
# kubectl --context="${CLUSTER2}" rollout status deploy/istio-ingressgateway -n istio-system --timeout=120s

exit 0;