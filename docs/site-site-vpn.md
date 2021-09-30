---
title: Site to Site VPN
summary: Site to Site VPN
authors:
  - Kamesh Sampath
date: 2021-09-22
---

## Demo Architecture

![Demo Architecture](./images/architecture.png){align=center}

## Create VPN Cloud Resources

!!!important
   It is highly recommended that you have static IP that will connect your Home network to GCP. Dynamic IP will require to re-run the configuration every time the IP changes.

The Google Cloud with VPC, VPN and setup Kubernetes using the VPC. This task will also setup a site-to-site VPN using [strongswan](https:/strongswan.org) which will allow communication between on-premise(VM) to the GKE.

As we have already setup the Kubernetes cluster in the earlier chapter, let us setup the VPN and configure the tunnel on our VM to make it communicate with the Kubernetes clusters in GKE,

```bash
make create-tunnel
```

## Intiate Tunnel

The tunnel is by default is not started automatically, to start the tunnel run the following command,

```bash
vagrant ssh -c 'sudo swanctl --initiate=home-gcp'
```

!!!note
   Ignore `AUTH_FAILED` log on the command output

If the connection is successful then your Google Cloud Console should *Established* as shown:

![Tunnel Connected](./images/tunnel_conn_established.png){align=center}

---8<--- "includes/abbrevations.md"
