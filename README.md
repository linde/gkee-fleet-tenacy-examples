# gkee-fleet-tenacy-examples
This repo hosts a few GKE Enterprise Fleet Tenancy examples

* [fleet-tenancy-with-defaults](fleet-tenancy-with-defaults) is an example of a couple concepts coming together
  * fleet-wide default settings for policy and config
  * a set of clusters that get those defaults bound to a team scope with a few namespaces attached
  * providing RBAC access of a configurable role to the respective namespaces

> **Note:**
> The HCL here is for illustrative purposes only. It is meant to share the concepts and some example usage, 
> not to represent production configuration. To that end, locals are used where generally vars would be in 
> order. Also, everthing is in one page, where possible, to faciliate comprehension.