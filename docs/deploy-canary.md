---
title: Deploy Microservices(Canary)
summary: Deploy Canary versions of the application.
authors:
  - Kamesh Sampath
date: 2021-09-03
---

At the end of this chapter you would have,

- [x] Deployed Canary App on VM
- [x] Create VM resources
- [x] Configure Isito Sidecar
- [x] Istio Control Plane resources

## Ensure environment

Set cluster environment variables

---8<--- "includes/env.md"

```bash
cd $TUTORIAL_HOME/work/mgmt
```

## Prepare Istio to Integrate VM Resources

For this demo we will make `Cluster-1` host the VM resources. For the VM integration we need to have `istiod` exposed via gateway.  The following sections deploys a set of Istio resources that will allow us to onboard VMs to Istio Servicemesh via `Cluster-1`.

```bash
kubectl --context=$CLUSTER1 apply -k $TUTORIAL_HOME/cluster/vm/istio
```

## Onboard VM Workloads

The VM workloads will be hosted on a namespace called `$VM_NAMESPACE` in `$CLUSTER1`. The VM workloads will be run using a Kubernetes SA called `$SERVICE_ACCOUNT`. There will be set of Istio resources that will be generated which need to be added to VM and configured to be used by Istio sidecar in the VM.

Before we create the necessary resources, let us set some environment variables for our convinience,

{== TODO update to be ansible variables ==}

```bash
export VM_APP="blue-green-canary"
export VM_NAMESPACE="vm-blue-green-canary"
export WORK_DIR="$TUTORIAL_HOME/cloud/private/vm"
export SERVICE_ACCOUNT="blue-green-canary"
export CLUSTER_NETWORK="bgc-network1"
export VM_NETWORK="bgc-vm-network"
export CLUSTER="cluster1"
```

Create the Namespace and SA,

```bash
kubectl --context=$CLUSTER1 apply -k $TUTORIAL_HOME/cluster/vm/workload
```

## Integrate VM with Istio

We now need create the isito resourceson VM and start the Istio sidecar service, we can do that by running the follwing command. The command will run set of Ansible Tasks that will setup and configure Istio sidecar on the VM.

```bash
make workload-run
```

## Create VM Mesh Resources

On Management Cluster,

```bash
envsubst < $TUTORIAL_HOME/mesh-files/vm/workload-destination.yaml | kubectl --context=$MGMT apply -f - 
```

On Cluster-1,

```bash
envsubst < $TUTORIAL_HOME/mesh-files/vm/service-workload-entry.yaml | kubectl --context=$CLUSTER1 apply -f - 
```

## Access Policies

!!! important
    Currently we cant route traffic to VMs, hence traffic distribution from the browser will still be only between Kubernetes services

{== Placeholder to check TP with VM when its avaiable ==}

### From VM

With `globalAccessPolicy` disabled in the virtual mesh, calling a Istio service from VM should go through successfully,

```text
[vagrant@fedora ~]$ http blue-green-canary.blue-green-canary.svc.cluster.local:8080/api
HTTP/1.1 200 OK
content-length: 137
content-type: application/json; charset=utf-8
date: Thu, 23 Sep 2021 14:06:46 GMT
etag: "89-coTFNpCn3MGCfccrhUII0cS8+hw"
server: envoy
vary: Accept-Encoding
x-envoy-upstream-service-time: 179

{
    "color": "blue",
    "count": 0,
    "greeting": "Namaste 🙏🏽",
    "pod": "blue-98db67777-797t7",
    "textColor": "whitesmoke",
    "userAgent": "HTTPie/2.5.0"
}
```

### To VM

We should also be able to access the VM from the cluster as shown,

```bash
kubectl exec -c network-utils -it $(kubectl get pods -lapp=network-utils --no-headers | awk '{print $1}')  -- curl blue-green-canary.vm-blue-green-canary.svc.cluster.local:8080/api
```

The command should show an output like,

```json
{"greeting":"Hola ✋🏽","count":1,"pod":"vm-192.168.68.114","color":"yellow","textColor":"black","userAgent":"curl/7.78.0"}
```
