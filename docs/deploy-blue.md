---
title: Deploy Microservices(Blue)
summary: Deploy Blue, Green and Canary versions of the application.
authors:
  - Kamesh Sampath
date: 2021-09-03
---

## Ensure environment

```bash
cd $TUTORIAL_HOME/work/cluster-1
```

## Deploy Blue Application

```bash
$TUTORIAL_HOME/bin/2_deploy_blue.sh "${CLUSTER1}"
```

## Deploy httpbin

The httpin application will be used to for checking various features of Gloo Mesh that you will be done in upcoming sections,

```bash
kubectl --context="${CLUSTER1}"  apply -f $TUTORIAL_HOME/extras/httpbin.yaml
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

Open the URL in the browser `open http://$SVC_GW_CLUSTER1`.

Or

Poll the service using the script,

```bash
$TUTORIAL_HOME/bin/call_bgc_service.sh "${CLUSTER1}"
```
