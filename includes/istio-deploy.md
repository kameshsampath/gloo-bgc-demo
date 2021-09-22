
Setup the Istio Operator,

```bash
istioctl operator init
```

Deploy Istio,

```bash
envsubst < $TUTORIAL_HOME/cluster/istio/istio-cr.yaml | kubectl apply -f -
```
