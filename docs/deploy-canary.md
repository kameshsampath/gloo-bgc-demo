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

Navigate to Tutorial home

```bash
cd $TUTORIAL_HOME
```

Set cluster environment variables

---8<--- "includes/env.md"

## Prepare Istio to Integrate VM Resources

For this demo we will make `Cluster-1` host the VM resources. For the VM integration we need to have `istiod` exposed via gateway.  We have enabled the istiod service and gateway when we [deployed](./env-setup.md#deploy-isito) Istio earlier.

Let use verify the same by runnig the command,

```bash
kubectl --context="${CLUSTER1}" get vs,gw -n istio-system
```

```text
NAME                                           GATEWAYS             HOSTS                                       AGE
virtualservice.networking.istio.io/istiod-vs   ["istiod-gateway"]   ["istiod.istio-system.svc.cluster.local"]   20h

NAME                                                                               AGE
gateway.networking.istio.io/cross-network-gateway                                  20h
gateway.networking.istio.io/istio-ingressgateway-istio-system-cluster1-gloo-mesh   22m
gateway.networking.istio.io/istiod-gateway                                         20h
```

## Onboard VM Workloads

In the following section we will canary version of the application as systemd service in the VM, deploy Istio Sidecar and integrate that with Istio on the `$CLUSTER1`.

As we did earlier let us run the following command that will run the requried Ansible tasks to create the `blue-green-canary` service, install enable and start Istio sidecar on the VM.

```bash
make workload-run
```

The successful run of workload setup would have created the following resources,

- VM blue-green-canay service's `Destination` and `Workload` on `$MGMT` cluster,

```bash
kubectl --context=$MGMT get destination,workload -n gloo-mesh
```

```text
NAME                                                                                      AGE
destination.discovery.mesh.gloo.solo.io/istio-ingressgateway-istio-system-cluster2        7h15m
destination.discovery.mesh.gloo.solo.io/istio-ingressgateway-istio-system-cluster1        7h46m
destination.discovery.mesh.gloo.solo.io/blue-green-canary-blue-green-canary-cluster1      108m
destination.discovery.mesh.gloo.solo.io/blue-green-canary-blue-green-canary-cluster2      97m
{==destination.discovery.mesh.gloo.solo.io/ blue-green-canary-vm-blue-green-canary-cluster1==}   51m 

NAME                                                                                         AGE
workload.discovery.mesh.gloo.solo.io/istio-ingressgateway-istio-system-cluster1-deployment   7h46m
workload.discovery.mesh.gloo.solo.io/istio-ingressgateway-istio-system-cluster2-deployment   7h15m
workload.discovery.mesh.gloo.solo.io/blue-blue-green-canary-cluster1-deployment              108m
workload.discovery.mesh.gloo.solo.io/green-blue-green-canary-cluster2-deployment             97m
{==workload.discovery.mesh.gloo.solo.io/blue-green-canary-vm-blue-green-canary-cluster1 ==}        20s
```

- VM blue-green-canay service's `Service` and `WorkloadEntry` on `$CLUSTER1` cluster. Note the `WorkloadEntry` IP address maps to the on-premise VM.

```bash
kubectl --context=$CLUSTER1 get service,workloadentry -n vm-blue-green-canary -o wide
```

```text
NAME                        TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE   SELECTOR
service/blue-green-canary   ClusterIP   172.18.8.152   <none>        8080/TCP   74m   app=blue-green-canary

NAME                                                  AGE   ADDRESS
workloadentry.networking.istio.io/blue-green-canary   74m   {== 192.168.68.119 ==}
```

!!!important
   Its is important for the workload entry *ADDRESS* to map to your local VM address for the integration to work correctly.

- The `Istio` service logs `/var/log/istio/istio.log` should reflect the successful connection with the `$CLUSTER1` istiod service (trimmed for brevity),

```text
2021-10-01T16:24:29.624607Z     warn    citadelclient   cannot load key pair, using token instead: open /etc/certs/
cert-chain.pem: no such file or directory
2021-10-01T16:24:29.772439Z     info    xdsproxy        connected to upstream XDS server: istiod.istio-system.svc:1
5012
2021-10-01T16:24:29.854536Z     info    cache   generated new workload certificate      latency=312.0443ms ttl=23h5
9m59.145478668s
2021-10-01T16:24:29.854584Z     info    cache   Root cert has changed, start rotating root cert
2021-10-01T16:24:29.854604Z     info    ads     XDS: Incremental Pushing:0 ConnectedEndpoints:0 Version:
2021-10-01T16:24:29.855134Z     info    cache   returned workload trust anchor from cache       ttl=23h59m59.144871
73s
2021-10-01T16:24:29.961145Z     info    ads     ADS: new connection for node:sidecar~192.168.68.119~ubuntu-focal.vm
-blue-green-canary~vm-blue-green-canary.svc.cluster.local-1
2021-10-01T16:24:29.961220Z     info    cache   returned workload certificate from cache        ttl=23h59m59.038785
303s
2021-10-01T16:24:29.961763Z     info    sds     SDS: PUSH       resource=default
2021-10-01T16:24:29.962475Z     info    ads     ADS: new connection for node:sidecar~192.168.68.119~ubuntu-focal.vm
-blue-green-canary~vm-blue-green-canary.svc.cluster.local-2
2021-10-01T16:24:29.962539Z     info    cache   returned workload trust anchor from cache       ttl=23h59m59.037464
545s
2021-10-01T16:24:29.962764Z     info    sds     SDS: PUSH       resource=ROOTCA
```

## Checking Connectivity

With us now having done all the necessary setup that has integrated our VM sidecar with `$CLUSTER1` Istio, let us check the connectivity from either side.

### From VM

With `globalAccessPolicy` disabled in the virtual mesh, calling a Istio service from VM should go through successfully,

```bash
vagrant ssh -c "http blue-green-canary.blue-green-canary.svc.cluster.local:8080/api"
```

```text
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
kubectl --context="$CLUSTER1" exec -c network-utils -it $(kubectl --context="$CLUSTER1" get pods -lapp=network-utils --no-headers | awk '{print $1}')  -- http blue-green-canary.vm-blue-green-canary.svc.cluster.local:8080/api
```

The command should show an output like,

```json
{"greeting":"Hola ✋🏽","count":1,"pod":"vm-192.168.68.114","color":"yellow","textColor":"black","userAgent":"curl/7.78.0"}
```

```text
HTTP/1.1 200 OK
content-length: 127
content-type: application/json; charset=utf-8
date: Sat, 02 Oct 2021 04:17:52 GMT
etag: "7f-DeWHCZhRbh4Y6bdigpjrPtHKI3U"
server: envoy
vary: Accept-Encoding
x-envoy-upstream-service-time: 208

{
    "color": "yellow",
    "count": 1,
    "greeting": "Hola ✋🏽",
    "pod": "vm-192.168.68.119",
    "textColor": "black",
    "userAgent": "HTTPie/2.5.0"
}
```

Awesome! We got the mechnanics working between VM and our Istio on `$CLUSTER1`. In upcoming chapters let us apply Gloo Mesh `TrafficPolicy` to distribute traffic between the `blue-green-canary` versions on `$CLUSTER1` and `$CLUSTER2` and the VM.