#!/usr/bin/env bash
set -eu
set -o pipefail

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do 
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" 
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

if [ -z "$VAGRANT_DEFAULT_PROVIDER" ];
then
  printf "No default provider for Vagrant exist, please configure \$VAGRANT_DEFAULT_PROVIDER before proceeding"
  exit 1
fi

TUTORIAL_HOME=$(realpath "$DIR/..")
CLOUD_DIR=$(realpath "$TUTORIAL_HOME/cloud/private")

pushd "$TUTORIAL_HOME" 1>/dev/null

# shellcheck disable=SC1091
. "$TUTORIAL_HOME/.venv/bin/activate"

pushd "$CLOUD_DIR" 1>/dev/null
# shellcheck disable=SC1091
source "$PWD/.envrc"

envsubst< "$CLOUD_DIR/Vagrantfile.tpl" > "$CLOUD_DIR/Vagrantfile"
envsubst< "$CLOUD_DIR/playbook.yml.tpl" > "$CLOUD_DIR/playbook.yml"

VAGRANT_STATE=$(vagrant status --machine-readable | awk -F"," 'NR==3{print $4}')

if [ "running" == "$VAGRANT_STATE" ];
then 
  vagrant provision
else
  vagrant up --provision
fi

popd 1>/dev/null
popd 1>/dev/null