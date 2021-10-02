---
title: Deploy Microservices(Blue)
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

## Deploy Blue Application

```bash
$TUTORIAL_HOME/bin/2_deploy_blue.sh "${CLUSTER1}"
```

Wait for the `blue-green-canary` deployment to be running,

```bash
kubectl --context="${CLUSTER1}" -n blue-green-canary rollout status deploy/blue
```

Let us ensure we got the services and deployments ready,

```bash
kubectl --context="${CLUSTER1}" -n blue-green-canary get pods,svc
```

```text
NAME                         READY   STATUS    RESTARTS   AGE
pod/green-5c798c7c9d-n4knk   2/2     Running   0          16s

NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/blue-green-canary   ClusterIP   10.100.145.63   <none>        8080/TCP   16s
```

## Create Gateway and Virtual Service

We need to create the Gateway and Virtual service for Blue-Green-Canary application. The gateway and virtual service will allow the application to be accessed via Istio Ingress Gateway,

```bash
$TUTORIAL_HOME/bin/test_gateway.sh "${CLUSTER1}"
```

Retrive the Istio Ingress Gateway url to access the application,

```bash
SVC_GW_CLUSTER1=$(kubectl --context ${CLUSTER1} -n istio-system get svc istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].*}')
```

### Check the Service

Call the service to check if its working,

```bash
$TUTORIAL_HOME/bin/call_bgc_service.sh "${CLUSTER1}"
```

The command should return an output like,

```json
{
    "color": "blue",
    "count": 0,
    "greeting": "Namaste 🙏🏽",
    "pod": "blue-6bd6f6bf89-2c6c9",
    "textColor": "whitesmoke",
    "userAgent": "HTTPie/2.5.0"
}
```
