#!/bin/bash

set -eu
set -o pipefail 

export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "$SCRIPT_DIR/currentEnv.sh"

source "$SCRIPT_DIR/helpers.sh"

if [ -z "$1" ];
then 
  echo "Please specify the context to use"
  exit 1
fi

kubectl --context="$1" apply -k "$TUTORIAL_HOME/demo-app/config/canary"