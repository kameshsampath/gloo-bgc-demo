---
title: Traffic Management
summary: Manage Traffic among the distributed services
authors:
  - Kamesh Sampath
date: 2021-09-14
---

At the end of this chapter you would have,

- [x] Applied Access Policies
- [x] Create TrafficPolicy to distribute traffic
- [x] Integrated VM Workload with Mesh

## Ensure environment

Set cluster environment variables

---8<--- "includes/env.md"

```bash
cd $TUTORIAL_HOME/work/mgmt
```

## Gloo Mesh Gateway

We will create Virtual Gateway, Host and RouteTable to route requests to the servies across the mesh cluster.

!!! important
    If you have installed the test gateway and virtual service, make sure to delete from the clusters before proceeding further

```bash
$TUTORIAL_HOME/bin/7_deploy_gateway.sh
```

Let us verify if Gateway and Virtual Services are created on both the clusters that are part of the mesh,

```bash
kubectl --context=${CLUSTER1} get gw,vs -A 
```

```bash
kubectl --context=${CLUSTER2} get gw,vs -A 
```

Both the commands should return an output like,

```text
NAMESPACE      NAME                                                                               AGE
{== istio-system   gateway.networking.istio.io/bgc-virtualgateway-17072781039916753854                42s ==}
istio-system   gateway.networking.istio.io/cross-network-gateway                                  5d12h
istio-system   gateway.networking.istio.io/istio-ingressgateway-istio-system-cluster1-gloo-mesh   16h
istio-system   gateway.networking.istio.io/istiod-gateway                                         5d12h

NAMESPACE      NAME                                                           GATEWAYS                                                   HOSTS                                       AGE
{== gloo-mesh      virtualservice.networking.istio.io/bgc-virtualhost-gloo-mesh   ["istio-system/bgc-virtualgateway-17072781039916753854"]   ["*"]                                       42s ==}
istio-system   virtualservice.networking.istio.io/istiod-vs                   ["istiod-gateway"]                                         ["istiod.istio-system.svc.cluster.local"]   37h
```

## Calling Service

---8<--- "includes/call-service.md"

## Traffic Policy

As we have unified the mesh we are good to distribute traffic amongst them. As part of the next section we will apply various traffic policies to distribute traffic amongst the `blue`, `green` and `canary` services.

### Green

As we already have traffic sent to *blue*, let use try sending all the traffic to *green*

```bash
$TUTORIAL_HOME/bin/8_green.sh
```

Now if you try to call the service via browser or cli as [described](traffic.md#calling-service) it should return response from *green* service.

### Canary

Let us now try sending all the traffic to *canary* service on the VM,

```bash
$TUTORIAL_HOME/bin/9_canary.sh
```

Now if you try to call the service via browser or cli as [described](traffic.md#calling-service) it should return response from *canary* service.

### Blue <-- --> Green

Let's try to split the traffic between *blue*(`50%`) and *green*(`50%`),

```bash
$TUTORIAL_HOME/bin/11_blue-green.sh
```

If you try check your browser you should see an alternating blue-green traffic.

## Blue,Green and Canary

Finally let's try to split the traffic between *blue*(`40%`),*green*(`40%`) and *canary*(`20%`),

```bash
$TUTORIAL_HOME/bin/12_blue-green-canary.sh
```

If you try check your browser you should see almost equal traffic to *blue* and *green* and few requests to *canary*.

---8<--- "includes/abbrevations.md"
