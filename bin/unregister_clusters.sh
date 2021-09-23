#!/bin/bash

set -eu
set -o pipefail 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/currentEnv.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/helpers.sh"


if [ -z "$1" ];
then 
  echo "Please pass the cluster context"
  exit 1
fi

if [ -z "$2" ];
then 
  echo "Please pass the cluster name"
  exit 1
fi

meshctl cluster deregister --mgmt-context="${MGMT}" --remote-context="$1" enterprise "$2" --kubeconfig="$KUBECONFIG"

exit 0;