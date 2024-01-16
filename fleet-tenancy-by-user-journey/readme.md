
# Overview

The following directories highlight terraform examples mapped to some user journeys.

## Platform Admin Provisioning

First, the [Platform Admin Provisioning](./platform-admin-provisioning/) journeys:

 * [project-level-setup](./platform-admin-provisioning/project-level-setup/)
 * [team-level-setup](./platform-admin-provisioning/team-level-setup/)
 * [team-resources](./platform-admin-provisioning/team-resources/)

In the above journeys, the Platform Admin provisions clusters and namespaces for the teams.

Additionally, there is also an example App Operator/SRE self service example:

* [team-self-service-namespace](./platform-admin-provisioning/team-self-service-namespace/)

In this the App Operator self service creates a team specific namespace and then deploys a workload to it using connecting information from the bound clusters. This uses Connect Gateway to manage the connection using the fleet membership.

#  Usage

The idea is to step through the various phases which, so far, are named in alphabetical order. We are using different terraform projects because this is expected in actual usage -- project level settings are separate from any specific team setup, etc. This allows for multiple teams to be set up under a fleet project independantly. Importantly, it also allows for teams to be torn down without coordinating affecting the critical fleet project.



```bash

cd platform-admin-provisioning/project-level-setup

# set variables however you'd prefer. minially you need to set the fleet_project
echo 'fleet_project = "stevenlinde-adhoc-2024-02"' > terraform.tfvars


terraform init
terraform plan
terraform apply 

# give it a little while so services are activated, then move to team level

cd ../team-level-setup/

# set variables, as desired. none are required at this step but you can 
# change the team name, for example.

terraform init
terraform plan
terraform apply 

# then move to team-resources

cd ../team-resources

# we provision clusters here, so require a cluster project. you can also set
# how it's name prefix and the nubmer of clusters, nodes, etc

# indicate in which project the clusters are located. we're putting them
# in the fleet project for simplicity, but you could have them elsewhere
echo 'cluster_project = "stevenlinde-adhoc-2024-02"' > terraform.tfvars


terraform init
terraform plan
terraform apply 


```

You can see what'd going on within the cluster(s) via the Cloud Console or kubectl:

```bash

BINDING_0=google_gke_hub_membership_binding.acme_scope_clusters[0]

PROJECT=$(echo ${BINDING_0}.project | terraform console | tr -d \")
MEMBERSHIP_0=$(echo ${BINDING_0}.membership_id | terraform console | tr -d \")
LOCATION=$(echo ${BINDING_0}.location | terraform console | tr -d \")

gcloud container clusters get-credentials --region $LOCATION --project=$PROJECT $MEMBERSHIP_0   

# verify the scope's namespaces are there as well as features' namespaces
kubectl get ns

# confirm crds from the features are there
kubectl get crds | grep istio
kubectl get crds | grep gatekeeper


```

## Self Service Namespace Provisioning

Finally, shift roles and as App Operator/SRE then:

```bash

cd ../team-self-service-namespace


# you can set variables (e.g. for the self serve namespace name), but defaults work ok

terraform init
terraform plan
terraform apply 


```

# TODO

* TODO figure out service accounts, in particular cascade of account creation for subsequent usage in providers. That is, in project level setup, create the google service account (with bindings for approp roles) used to create the team setup. in team setup, create the service account used to subsequently create resources and create a service account to self service namespaces, etc.

