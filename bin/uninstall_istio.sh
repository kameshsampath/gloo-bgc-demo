#!/bin/bash

set -eu
set -o pipefail 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "$SCRIPT_DIR/currentEnv.sh"

source "$SCRIPT_DIR/helpers.sh"

export KUBECONFIG=$TUTORIAL_HOME/work/.kube/config

# Operator Uninstall
kubectl --context="${CLUSTER1}" delete istiooperators.install.istio.io -n istio-system --all

kubectl --context="${CLUSTER2}" delete istiooperators.install.istio.io -n istio-system --all

istioctl operator remove --context="${CLUSTER1}"
kubectl --context="${CLUSTER1}"  delete ns istio-operator --grace-period=0 --force 

istioctl operator remove --context="${CLUSTER2}"
kubectl --context="${CLUSTER2}"  delete ns istio-operator --grace-period=0 --force 

# Cleanup Istio Resources
istioctl manifest generate | kubectl --context="${CLUSTER1}" delete -f -
kubectl --context="${CLUSTER1}"  delete ns istio-system --grace-period=0 --force

istioctl manifest generate | kubectl --context="${CLUSTER2}" delete -f -
kubectl --context="${CLUSTER2}"  delete ns istio-system --grace-period=0 --force 

exit 0;