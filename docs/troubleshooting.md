---
title: Troubleshooting
summary: Troubleshooting demo.
authors:
  - Kamesh Sampath
date: 2021-09-03
---

## Tunnel Closed

The VPN tunnel goes inactive if there is no activity, whenever you see the Tunnel is inactive say you are not able to ping the Pods, try restarting the `strongswan` service and initiate the connection,

```bash
vagrant ssh -c "sudo systemctl restart strongswan"
```

```bash
vagrant ssh -c "sudo swanctl initiate --child=home-gcp"
```
