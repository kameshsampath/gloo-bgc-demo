
```bash
export MGMT=$(export KUBECONFIG=$TUTORIAL_HOME/work/mgmt/kubeconfig && kubectl config get-contexts -o name | tr -d '\n\r')
export CLUSTER1=$(export KUBECONFIG=$TUTORIAL_HOME/work/cluster-1/kubeconfig && kubectl config get-contexts -o name | tr -d '\n\r')
export CLUSTER2=$(export KUBECONFIG=$TUTORIAL_HOME/work/cluster-2/kubeconfig && kubectl config get-contexts -o name | tr -d '\n\r')
```

!!!tip
   It will be a nice convinience to have a merged kubeconfig to easier context switch. To merge kube config run the following command,

   ```bash
      mkdir -p $TUTORIAL_HOME/work/.kube
      KUBECONFIG=$TUTORIAL_HOME/work/mgmt/kubeconfig:$TUTORIAL_HOME/work/cluster-1/kubeconfig:$TUTORIAL_HOME/work/cluster-2/kubeconfig; kubectl config view --flatten > $TUTORIAL_HOME/work/.kube/config
      export KUBECONFIG=$TUTORIAL_HOME/work/.kube/config
   ```
