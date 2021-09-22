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
$TUTORIAL_HOME/bin/6_deploy_gateway.sh
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

Let's try accesing the application via browser you can use either of the Istio Gateway Ingress Addresses from Cluster1 or Cluster2:

```bash
$TUTORIAL_HOME/bin/browse_bgc_service.sh "${CLUSTER1}"
```

(OR)

```bash
$TUTORIAL_HOME/bin/browse_bgc_service.sh "${CLUSTER2}"
```

The browser should now alternate between Blue and Green versions,

![blue and green](https://www.screencast.com/users/KameshS/folders/Snagit/media/1854757a-50b3-4802-99df-29bde2ebfa7d/embed){ align=center }

You can also poll the service via CLI:

```bash
$TUTORIAL_HOME/bin/poll_bgc_service.sh "${CLUSTER1}"
```

(OR)

```bash
$TUTORIAL_HOME/bin/poll_bgc_service.sh "${CLUSTER2}"
```

<script id="asciicast-435817" src="https://asciinema.org/a/435817.js" async></script>

## Traffic Policy

As we have unified the mesh and defined the access policy, we are good to distribute traffic amongst them.

### Blue

Let's try to split the traffic (blue),

```bash
kubectl --context=${MGMT} apply -f $TUTORIAL_HOME/mesh-files/blue-traffic-policy.yaml
```

### Green

### Blue <--> Green

Let's try to split the traffic (green),

```bash
kubectl --context=${MGMT} apply -f $TUTORIAL_HOME/mesh-files/green-traffic-policy.yaml
```

Check if the access control has been applied by accessing the service,

Poll the service using the script,

### Poll Cluster 1

```bash
$TUTORIAL_HOME/bin/poll_bgc_service.sh "${CLUSTER1}"
```

After few seconds you should start to get response like,

```text
{
    "color": "blue",
    "count": 2,
    "greeting": "Namaste 🙏🏽",
    "pod": "localhost",
    "userAgent": "HTTPie/2.5.0"
}
```

### Poll Cluster 2

```bash
$TUTORIAL_HOME/bin/poll_bgc_service.sh "${CLUSTER2}"
```

After few seconds you should start to get response like,

```text
{
    "color": "green",
    "count": 4,
    "greeting": "Bonjour 👋🏽",
    "pod": "localhost",
    "userAgent": "HTTPie/2.5.0"
}
```

---8<--- "includes/abbrevations.md"

