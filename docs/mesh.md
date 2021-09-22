---
title: Mesh
summary: Configure Gloo Mesh resources
authors:
  - Kamesh Sampath
date: 2021-09-14
---

At the end of this chapter you would have,

- [x] Created Virtual Mesh to connect Cluster-1 and Cluster-2
- [x] Applied Access Policies
- [x] Create TrafficPolicy to distribute traffic
- [x] Integrated VM Workload with Mesh

## Ensure environment

Set cluster environment variables

---8<--- "includes/env.md"

```bash
cd $TUTORIAL_HOME/work/mgmt
```

## Enable PeerAuthentication

Let us configure Istio `PeerAuthentication` in `$CLUSTER1` and `$CLUSTER2`. `PeerAuthentication` enable the mTLS between service mesh services and will help in unifying the ROOT CA between heterogenous service meshes and make the service across each other to be treated as on mesh. {== TODO better explanation ==},

### Cluster 1

```bash
kubectl --context=${CLUSTER1} apply -f $TUTORIAL_HOME/mesh-files/peer-auth.yaml
```

### Cluster 2

```bash
kubectl --context=${CLUSTER2} apply -f $TUTORIAL_HOME/mesh-files/peer-auth.yaml
```

## Virtual Mesh

Virtual Mesh allows seamless communication between meshes,

```bash
kubectl --context=${MGMT} apply -f $TUTORIAL_HOME/mesh-files/bgc-virtual-mesh.yaml
```

## Apply Access Policy

As the mesh is enabled with Strict Access Policy, we need to setup the policy to allow Istio Ingress Service Account to access the service,

```bash
kubectl --context=${MGMT} apply -f $TUTORIAL_HOME/mesh-files/policy/bgc-access-policy.yaml
```

And now when call or poll the service you should see traffic distributed among the the services allowed by the policy,

---8<--- "includes/call-service.md"

---8<--- "includes/abbrevations.md"
