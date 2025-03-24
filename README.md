# gke-multi-cluster-examples
This repo hosts a few GKE Multi-cluster Tenancy examples

* [fleet-tenancy-with-defaults](fleet-tenancy-with-defaults) is an example of a couple concepts coming together
  * fleet-wide default settings for policy and config
  * a set of clusters that get those defaults bound to a team scope with a few namespaces attached
  * providing RBAC access of a configurable role to the respective namespaces
* [fleet-tenancy-by-user-journey](fleet-tenancy-by-user-journey) explores [tenancy provisioning](./fleet-tenancy-by-user-journey/platform-admin-provisioning) by distinct steps:
    * [project-level-setup](./fleet-tenancy-by-user-journey/platform-admin-provisioning/project-level-setup) once per project
    * then per [team-level-setup](fleet-tenancy-by-user-journey/platform-admin-provisioning/team-level-setup) and [team-resources](fleet-tenancy-by-user-journey/platform-admin-provisioning/team-resources) for them like clusters with appropriate observability.
    * and finally, after a handoff, [team self service](fleet-tenancy-by-user-journey/platform-admin-provisioning/team-self-service-namespace) namespace and cluster resource provisioning.
* [deploying-multi-cluster-gateways](deploying-multi-cluster-gateways) works out the terraform necessary for the example [deploying-multi-cluster-gateways](https://cloud.google.com/kubernetes-engine/docs/how-to/deploying-multi-cluster-gateways).



> **Note:**
> The HCL here is for illustrative purposes only. It is meant to share the concepts and some example usage, 
> not to represent production configuration. 
