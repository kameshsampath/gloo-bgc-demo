#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/currentEnv.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/helpers.sh"
if [ -z "$1" ];
then 
  echo "Please specify the context to use"
  exit 1
fi

kubectl --context="${1}" apply \
  -n "${2:-blue-green-canary}" \
  -k "$TUTORIAL_HOME/demo-app/config/istio"