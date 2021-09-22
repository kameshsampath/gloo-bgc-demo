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
cd $TUTORIAL_HOME/work/vm
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

With existing acess policy when you try to access the Cluster service from the ClustVM you should see `RABC: access denied` as shown, 

```text
[vagrant@fedora ~]$ http blue-green-canary.blue-green-canary.svc.cluster.local:8080/api
HTTP/1.1 403 Forbidden
content-length: 19
content-type: text/plain
date: Wed, 22 Sep 2021 14:12:34 GMT
server: envoy
x-envoy-upstream-service-time: 176

RBAC: access denied
```

Let us allow the traffic from VM to Cluster by applying the AccessPolicy,

```bash
kubectl --context=$MGMT apply -f $TUTORIAL_HOME/mesh-files/policy/from-vm-access-policy.yaml
```

Now trying to do acccess the cluster service from vm,

```bash
http blue-green-canary.blue-green-canary.svc.cluster.local:8080/api
```

Will show an output like

```text

```

### To VM

With existing acess policy when you try to access the VM service from the Cluster you should see access denied,

```bash

```

```bash
kubectl --context=$MGMT apply -k $TUTORIAL_HOME/mesh-files/policy
```

No uncomment the `from-vm-access.policy.yaml` in `$TUTORIAL_HOME/mesh-files/policy/kustomization.yaml` and reapply the policy to allow access from VM,

```bash
kubectl --context=$MGMT apply -f $TUTORIAL_HOME/mesh-files/policy/
```
