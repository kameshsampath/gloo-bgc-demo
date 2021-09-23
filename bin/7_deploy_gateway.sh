#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "$SCRIPT_DIR/currentEnv.sh"

source "$SCRIPT_DIR/helpers.sh"

kustomize build "$TUTORIAL_HOME/mesh-files/routing" \
  | envsubst | kubectl --context="${MGMT}" apply -f -