---
title: Deploy Microservices(Green)
summary: Deploy Blue, Green and Canary versions of the application.
authors:
  - Kamesh Sampath
date: 2021-09-03
---

Navigate to $CLUSTER2 work folder

```bash
cd $TUTORIAL_HOME/work/mgmt
```

## Deploy Green Application

```bash
$TUTORIAL_HOME/bin/3_deploy_green.sh "${CLUSTER2}"
```

## Deploy httpbin

The httpin application will be used to for checking various features of Gloo Mesh that you will be done in upcoming sections,

```bash
kubectl --context="${CLUSTER2}"  apply -f $TUTORIAL_HOME/extras/httpbin.yaml
```

## Create Gateway and Virtual Service

We need to create the Gateway and Virtual service for Blue-Green-Canary application. The gateway and virtual service will allow the application to be accessed via Istio Ingress Gateway,

```bash
$TUTORIAL_HOME/bin/test_gateway.sh "${CLUSTER2}"
```

And now when call or poll the service you should see traffic distributed among the the blue and green,

---8<--- "includes/call-service.md"
