# fleet-tenancy-with-defaults

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

[TODO add some kubectl and gcloud examples to show what's happening]

