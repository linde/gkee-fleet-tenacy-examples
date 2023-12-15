# Fleet Tenancy with Defaults

> **Note:**
> The HCL here is for illustrative purposes only. It is meant to share the concepts and some
> example usage, not to represent production configuration. To that end, locals are used 
> where generally vars would be in order. Also, everthing is in one page, where possible,
> to faciliate comprehension.


This repo is an example of a couple concepts coming together:

  * fleet-wide default settings for policy and config
  * a set of clusters that get those defaults bound to a team scope with a few namespaces attached
  * providing RBAC access of a configurable role to the respective namespaces

# Setup

In order to check out this example, you'll need to adjust the `locals` in [main.tf](main.tf) for your enviroment. In particular, you'll want to take note of the ConfigSync settings in `google_gke_hub_feature.fleet_config_defaults` -- they point to the public git repo of _this_ content; if you want to tweak things, you'll want to update this.

About this setting -- `fleet_default_member_config` within a `google_gke_hub_feature` resource only affect *new* clusters. If you update this, it doesnt get propagated to existing clusters without prompting. We are working on progressive rollout mechanisms to do this for production usage, but for smaller setups and local testing, you can make changes via `gcloud container fleet config-management fetch-for-apply` and then `gcloud container fleet config-management apply` ([details](https://cloud.google.com/sdk/gcloud/reference/alpha/container/fleet/config-management/fetch-for-apply)).

# Usage

Once that's done, follow the standard initial teraform steps:

```bash
terraform init
terraform plan
terraform apply
```

# Things to check

First set some environment variables based on the terraform state:

```bash

export PROJECT=$(echo google_container_cluster.acme_clusters[0].project | terraform console | sed s/\"//g)
export CLUSTER_LOCATION=$(echo google_container_cluster.acme_clusters[0].location | terraform console | sed s/\"//g)

export MEMBERSHIP=$(echo google_gke_hub_membership_binding.acme_scope_clusters[0].membership_id | terraform console | sed s/\"//g)
export SCOPE=$(echo google_gke_hub_scope.acme_scope.scope_id | terraform console | sed s/\"//g)

```

Now we cam see the Fleet Tenancy GCP resources we made and get credentials to 
explore the k8s resources on the cluster:


```bash

gcloud container fleet memberships list --project=$PROJECT

gcloud container fleet scopes list --project=$PROJECT

gcloud container fleet scopes namespaces  list --project=$PROJECT  --scope=$SCOPE

gcloud container fleet memberships --project=$PROJECT  get-credentials --location=$CLUSTER_LOCATION  $MEMBERSHIP

```

and in k8s, we can see hub and configsync managed resources:

```bash

# should show namespaces in local.namespace_names
kubectl get ns -l "fleet.gke.io/fleet-scope=acme-corp-products-team"

# should show networkpolicy in every namespace in the scope
kubectl get networkpolicy --all-namespaces

```

# This to try

* add a new namespace in `locals.namespace_names` and see it propagate and get resources with the namespace selector in configsync.