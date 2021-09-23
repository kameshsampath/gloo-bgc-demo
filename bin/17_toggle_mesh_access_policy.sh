#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "$SCRIPT_DIR/currentEnv.sh"

source "$SCRIPT_DIR/helpers.sh"

CURRENT_ACCESS_POLICY=$(yq eval '.spec.globalAccessPolicy' "$TUTORIAL_HOME/mesh-files/bgc-virtual-mesh.yaml")

if [ "ENABLED" == "$CURRENT_ACCESS_POLICY" ];
then
  printf "\n Global Access Policy is currently enabled, disabling it. \n"
  yq eval -i '.spec.globalAccessPolicy = "DISABLED"' "$TUTORIAL_HOME/mesh-files/bgc-virtual-mesh.yaml"
  printf "\n Purging existing Access policies..\n"
  kubectl --context="${MGMT}" delete -f  "$TUTORIAL_HOME/mesh-files/policy"  || true
else
  printf "\n Global Access Policy is currently disabled, enabling it. \n"
  yq eval -i '.spec.globalAccessPolicy = "ENABLED"' "$TUTORIAL_HOME/mesh-files/bgc-virtual-mesh.yaml"
fi

kubectl --context="${MGMT}" apply -f  "$TUTORIAL_HOME/mesh-files/bgc-virtual-mesh.yaml"