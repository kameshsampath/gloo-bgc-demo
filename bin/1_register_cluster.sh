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

printf "####################################################################"
printf "\n Registering cluster '%s' as '%s'\n" "$1" "$2"
printf "####################################################################\n"

RELAY_ADDRESS="$(kubectl --context "${MGMT}" -n gloo-mesh get svc enterprise-networking -o jsonpath='{.status.loadBalancer.ingress[0].*}'):9900"
CLUSTER_DOMAIN=cluster.local

meshctl cluster register \
  --mgmt-context="${MGMT}" \
  --remote-context="$1" \
  --relay-server-address="${RELAY_ADDRESS}" \
  --cluster-domain="${CLUSTER_DOMAIN}" \
  enterprise "$2"

exit 0;