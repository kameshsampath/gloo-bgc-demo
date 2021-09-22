#!/bin/bash

set -eu
set -o pipefail

MINIKUBE_IP=$(minikube -p"$PROFILE_NAME" ip)
MINIKUBE_CIDR="${MINIKUBE_IP%.*}.0/24"
# TODO check if this works in GNU
read -ra arr <<<"$(ifconfig -lu)"

for i in "${arr[@]}";
do
if ifconfig "$i" | grep -Eq "^\s*inet\s*${MINIKUBE_IP%.*}.*$";
then
   bound_ips=("$(arp-scan -I "$i" "$MINIKUBE_CIDR" -x | awk '{print $1}')")
   #192.168.x.1 is always reserved for host we will skip it
   for ip in ${MINIKUBE_IP%.*}.{2..255};
   do
      if ! printf '%s\n' "${bound_ips[@]}" | grep -Eq "^$ip$";
      then
        printf "\nExport and Use the following variables in vm Vagrant file :\n"
        printf 'export MINIKUBE_BRIDGE="%s"\n' "$i"
        printf 'export VM_IP="%s"\n' "$ip"
        export MINIKUBE_BRIDGE="$i"
        export VM_IP="$ip"
        exit 0
      fi
   done;
fi
done;
exit 0
