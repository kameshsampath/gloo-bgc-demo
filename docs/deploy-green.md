---
title: Deploy Microservices(Green)
summary: Deploy Blue, Green and Canary versions of the application.
authors:
  - Kamesh Sampath
date: 2021-09-03
---

## Ensure environment

Navigate to Tutorial home

```bash
cd $TUTORIAL_HOME
```

Set cluster environment variables

---8<--- "includes/env.md"

## Deploy Green Application

```bash
$TUTORIAL_HOME/bin/3_deploy_green.sh "${CLUSTER2}"
```

Wait for the `blue-green-canary` deployment to be running,

```bash
kubectl --context="${CLUSTER2}" -n blue-green-canary rollout status deploy/green
```

Let us ensure we got the services and deployments ready,

```bash
kubectl --context="${CLUSTER2}" -n blue-green-canary get pods,svc
```

```text
NAME                        READY   STATUS    RESTARTS   AGE
pod/green-6bd6f6bf89-2c6c9   2/2     Running   0          3m5s

NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/blue-green-canary   ClusterIP   172.18.10.239   <none>        8080/TCP   3m6s
```

## Create Gateway and Virtual Service

We need to create the Gateway and Virtual service for Blue-Green-Canary application. The gateway and virtual service will allow the application to be accessed via Istio Ingress Gateway,

```bash
$TUTORIAL_HOME/bin/test_gateway.sh "${CLUSTER2}"
```

### Check the Service

Call the service to check if its working,

```bash
$TUTORIAL_HOME/bin/call_bgc_service.sh "${CLUSTER2}"
```

The command should return an output like,

```json
{
    "color": "green",
    "count": 0,
    "greeting": "Bonjour 👋🏽",
    "pod": "green-5c798c7c9d-n4knk",
    "textColor": "whitesmoke",
    "userAgent": "HTTPie/2.5.0"
}
```
