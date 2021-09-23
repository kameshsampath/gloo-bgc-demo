#!/bin/bash

set -eu
set -o pipefail 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/currentEnv.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/helpers.sh"

export KUBECONFIG=$TUTORIAL_HOME/work/.kube/config

if [ -z "$1" ];
then 
  echo "Please pass the cluster context"
  exit 1
fi

printf "\n Uninstalling Istio on cluster '%s' \n" "${1}"

# Operator Uninstall
kubectl --context="$1" delete istiooperators.install.istio.io -n istio-system --all

istioctl operator remove --context="$1"
kubectl --context="$1"  delete ns istio-operator --grace-period=0 --force 

# Cleanup Istio Resources
istioctl manifest generate | kubectl --context="$1" delete -f - || true
kubectl --context="$1"  delete ns istio-system --grace-period=0 --force--force 

exit 0;