---
title: Envrionment Setup
summary: Setup the Hybrid Cloud Envrionment and install and configure Gloo Mesh Enterprise.
authors:
  - Kamesh Sampath
date: 2021-09-03
---

At the end of this chapter you would have,

- [x] Three Kubernetes Clusters on AWS,GCP and Civo
- [x] The VM on local environment
- [x] Installed Gloo Mesh Enterprise

## Demo Environment

The demo requires us to have three Kubernetes clusters and one Virtual Machine. The following tables shows the environment to component matrix.

| Components  | GCP | AWS | CIVO | VM
| ----------- | --- | --- | ---- | --
| Gloo Mesh Management | :material-close: | :material-close: | :material-check: | :material-close:
| Gloo Mesh Agent | :material-check: | :material-check: | :material-close: | :material-close:
| Kubernetes | :material-check: | :material-check: | :material-check: | :material-close:
| Istio | :material-check: | :material-check: | :material-close: | :material-check:
| Blue-Green-Canary Service | :material-check: | :material-check: | :material-close: | :material-check:

Navigate to the `$TUTORIAL_HOME`,

```bash
cd $TUTORIAL_HOME
```

Create the Ansible variables file,

```bash
make encrypt-vars
```

!!!note
  As we will having sensitive keys in the Ansible variables, its highly recommended to create an encrypted variables file.

The following table shows the ansible variables used, do update the values of the file as per your environment.

| Variable               | Description              | Default
| ---------------------- | ------------------------ | -----------|
|`gcp_vpc_name`| The name of the VPC that will be created. Same VPC will be used with GKE Cluster| kameshs-k8s-vpc
|`gcp_vpn_name`| The name of the VPN that will be created | kameshs-site-to-site-vpn
|`gcp_cred_file`| The SA JSON file to be copied to VM | "$HOME/.config/gcloud/credentials" from the Ansible controller  machine
|`gcp_project`| The GCP project to use |
|`gcp_region`| The GCP region to use| asia-south-1
|`aws_access_key_id`| The AWS Acess Key|
|`aws_secret_access_key`| The AWS Secret Key|
|`aws_region`| The AWS Region to use | ap-south-1
|`eks_cluster_name`| The AWS EKS cluster name | kameshs-gloo-demos
|`aws_vpc_name`| The AWS VPC name. The same VPC will be used with EKS cluster | kameshs-gloo-demos
|`civo_api_key`| The CIVO Cloud API Key |
|`force_app_install`| Force install application on VM| no
|`clean_istio_vm_files`| Clean the generated Istio VM files | no
|`k8s_context`| The kubernetes context that will be used to query Istio resources |

## VM Setup

We will use [Vagrant](http://vagrantup.com) to run and configure our workload VM.  The Workload VM also serves as our Ansible target host to run the ansible playbooks.

```bash
make vm-up
```

Once the vm is up run the following command to setup create the cloud ressources,

### Cloud Setup

The cloud setup will setup the Clouds and create Kubernetes clusters on them. On GCP the setup will also create VPN to connect your local network to Google Cloud VPC.

```bash
make cloud-run
```

!!! note
  The step above will take approx 30-40 mins to complete

### Deploy Istio

We will deploy istio to all our workload clusters, in our setup AWS and GCP are workload clusters, run the following command to install the istio,

```bash
cd $TUTORIAL_HOME/work/mgmt
```

Install Istio on `cluster-1`:

```bash
$TUTORIAL_HOME/bin/install_istio.sh "$CLUSTER1"
```

Install Istio on `cluster-2`:

```bash
$TUTORIAL_HOME/bin/install_istio.sh "$CLUSTER2"
```

## Ensure Environment

Make sure you have the Gloo Mesh Gateway Enterprise License Key before proceeding to install. Export the license key to variable,

```shell
export GLOO_MESH_GATEWAY_LICENSE_KEY=<your Gloo Mesh Gateway EE License Key>
```

## Download meshctl

Download and install latest **meshctl** by running,

```shell
curl -sL https://run.solo.io/meshctl/install | sh
```

Add meshctl to the system path,

```shell
export PATH=$HOME/.gloo-mesh/bin:$PATH
```

Set cluster environment variables

---8<--- "includes/env.md"

Navigate to management work folder,

```bash
cd $TUTORIAL_HOME/work/mgmt
```

## Install Gloo Mesh Enterprise

Create the `gloo-mesh` namespace to install `Gloo Mesh`,

```bash
$TUTORIAL_HOME/bin/install_mesh.sh
```

!!! note
    - You can safely ignore the helm warnings
    - It will take few minutes for the Gloo Mesh to be installed and ready

Let us verify if all components are installed,

```bash
meshctl check server
```

```text
Gloo Mesh Management Cluster Installation
--------------------------------------------

🟢 Gloo Mesh Pods Status

🟡 Gloo Mesh Agents Connectivity
    Hints:
    * No registered clusters detected. To register a remote cluster that has a deployed Gloo Mesh agent, add a KubernetesCluster CR.
      For more info, see: https://docs.solo.io/gloo-mesh/latest/setup/cluster_registration/enterprise_cluster_registration/

Management Configuration
---------------------------
2021-09-14T06:41:10.594255Z     info    klog    apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition

🟢 Gloo Mesh CRD Versions

🟢 Gloo Mesh Networking Configuration Resources
```

## Cluster Registrations

To connect our hetregenous Isito clusters, we need to register them with the management cluster. The cluster registration will communicate with Management cluster via an `enterprise-agent`, we need to pass the enterprise-agent address as part of cluster registrations to enable effective communcation.

Register `$CLUSTER1` as `cluster1`:

```bash
$TUTORIAL_HOME/bin/1_register_cluster.sh $CLUSTER1 cluster1
```

Register `$CLUSTER2` as `cluster2`:

```bash
$TUTORIAL_HOME/bin/1_register_cluster.sh $CLUSTER2 cluster2
```

## Verify Install

Let us verify if all components are installed,

```bash
meshctl check server
```

```text
Gloo Mesh Management Cluster Installation
--------------------------------------------

🟢 Gloo Mesh Pods Status
+----------+------------+-------------------------------+-----------------+
| CLUSTER  | REGISTERED | DASHBOARDS AND AGENTS PULLING | AGENTS PUSHING  |
+----------+------------+-------------------------------+-----------------+
| cluster1 | true       |                             2 |               1 |
+----------+------------+-------------------------------+-----------------+
| cluster2 | true       |                             2 |               1 |
+----------+------------+-------------------------------+-----------------+

🟢 Gloo Mesh Agents Connectivity

Management Configuration
---------------------------
2021-09-14T04:56:04.288180Z     info    klog    apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition

🟢 Gloo Mesh CRD Versions

🟢 Gloo Mesh Networking Configuration Resources
```

## Mesh Dashboard

We will us the Gloo Mesh Dashboard to verify our registered clusters,

```bash
kubectl --context=$MGMT port-forward -n gloo-mesh  deployment/dashboard 8090:8090
```

You can then open the [dashboard](http://localhost:8090){_target=blank} in your browser which will open a page as shown:

![Gloo Mesh Dashboard](./images/mesh_dashboard.png)
