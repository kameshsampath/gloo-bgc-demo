
## Deploy httpbin

The httpin application will be used to for checking various features of Gloo Mesh that you will be done in upcoming sections,

```bash
kubectl --context="${CLUSTER1}"  apply -f $TUTORIAL_HOME/extras/httpbin.yaml
```

### Start Tunnel

The tunnel is by default is not started automatically, to start the tunnel run the following command,

```bash
vagrant ssh -c 'sudo swanctl --initiate=home-gcp'
```

A successfuly command execution should return an output like,

```text
[IKE] initiating IKE_SA gw-gw[1] to xx.xx.xxx.xx
[ENC] generating IKE_SA_INIT request 0 [ SA KE No N(NATD_S_IP) N(NATD_D_IP) N(FRAG_SUP) N(HASH_ALG) N(REDIR_SUP) ]
[NET] sending packet: from 192.168.68.119[500] to xx.xx.xxx.xx[500] (712 bytes)
[NET] received packet: from xx.xx.xxx.xx[500] to 192.168.68.119[500] (712 bytes)
[ENC] parsed IKE_SA_INIT response 0 [ SA KE No N(NATD_S_IP) N(NATD_D_IP) N(FRAG_SUP) N(HASH_ALG) N(MULT_AUTH) ]
[CFG] selected proposal: IKE:AES_GCM_16_256/PRF_HMAC_SHA2_512/MODP_4096
[IKE] local host is behind NAT, sending keep alives
[CFG] no IDi configured, fall back on IP address
[IKE] authentication of '192.168.68.119' (myself) with pre-shared key
[IKE] establishing CHILD_SA home-gcp{2}
[ENC] generating IKE_AUTH request 1 [ IDi AUTH SA TSi TSr N(MULT_AUTH) N(EAP_ONLY) N(MSG_ID_SYN_SUP) ]
[NET] sending packet: from 192.168.68.119[4500] to xx.xx.xxx.xx[4500] (281 bytes)
[NET] received packet: from xx.xx.xxx.xx[4500] to 192.168.68.119[4500] (65 bytes)
[ENC] parsed IKE_AUTH response 1 [ N(AUTH_FAILED) ]
[IKE] received AUTHENTICATION_FAILED notify error
initiate failed: establishing CHILD_SA 'home-gcp' failed
```

Ignore `AUTHENTICATION_FAILED` log on the command output as long as your Google Cloud Console for VPN shows the status as *Established*:
