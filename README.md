# Gloo Hybrid Cloud Demo 
A short tutorial/demo we will be deploying a simple colored hello world microservice and explore how to integrate the service running on an on-premise VM with public cloud clusters using Istio. We will also leverage Gloo Mesh federation capabilites to unify the Istio clusters to provide better interoprablity between the clusters and VM. 

## What we wil be doing as part of this demo ?

- [x] Setup Kubernetes clusters on three public clouds
- [x] Setup Virutal Machine on on-premise network
- [x] Site-to-Site VPN to connect on-premise to public cloud
- [x] Deploy Gloo Mesh Enterprise on clusters
- [x] Deploy Istio on clusters
- [x] Deploy Istio sidecar on VM
- [x] Traffic Distribution between VM on-premise and public cloud
- [x] Access Policies to control traffic

![Demo Architecture](docs/images/architecture.png)

Check the [HTML documentation](https://kameshsampath.github.io/gloo-hybrid-cloud-demo/) that walks you step step in setting up and running the exercises by yourself
