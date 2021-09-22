#!/bin/bash

CURR_CTX=$(kubectl config current-context)

CURR_NS="$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"${CURR_CTX}\")].context.namespace}")" \
    || exit_err "error getting current namespace"

if [[ -z "${CURR_NS}" ]];
then
  CURR_NS='one'
else
  CURR_NS="${CURR_NS}"
fi

kubectl -n $CURR_NS  replace -f src/main/istio/Virtual_service_canary.yml