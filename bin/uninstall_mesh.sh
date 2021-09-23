#!/bin/bash

set -eu
set -o pipefail 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/currentEnv.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/helpers.sh"

export KUBECONFIG=$TUTORIAL_HOME/work/.kube/config

meshctl cluster deregister --mgmt-context="${MGMT}" --remote-context="${CLUSTER1}" enterprise cluster1 --kubeconfig="$KUBECONFIG"

meshctl cluster deregister --mgmt-context="${MGMT}" --remote-context="${CLUSTER2}" enterprise cluster2 --kubeconfig="$KUBECONFIG"

kubectl --context="${MGMT}" delete  -k "$TUTORIAL_HOME/mesh-files/networking" || true
kubectl --context="${MGMT}" delete  -f "$TUTORIAL_HOME/mesh-files/" || true

helm repo add gloo-mesh-enterprise https://storage.googleapis.com/gloo-mesh-enterprise/gloo-mesh-enterprise 
helm repo update

helm uninstall gloo-mesh-enterprise --namespace gloo-mesh --kube-context "${MGMT}"

kubectl --context="${CLUSTER2}" delete namespace gloo-mesh || true
kubectl --context="${CLUSTER1}" delete namespace gloo-mesh || true
kubectl --context="${MGMT}" delete namespace gloo-mesh || true

exit 0;