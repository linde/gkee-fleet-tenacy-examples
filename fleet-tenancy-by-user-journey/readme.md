
# Overview

The following directories highlight terraform examples mapped to some user journeys.

First, the [Platform Admin Provisioning](./platform-admin-provisioning/) journeys:

 * [project-level-setup](./platform-admin-provisioning/project-level-setup/)
 * [team-level-setup](./platform-admin-provisioning/team-level-setup/)
 * [team-resources](./platform-admin-provisioning/team-resources/)

In the above journeys, the Platform Admin provisions clusters and namespaces for the teams.

Going forward we will also add user journeys where Platform Admin/SRE self services.


#  Usage

The idea is to step through the various phases which, so far, are named in alphabetical order. We are using different terraform projects because this is expected in actual usage, project level settings are separate from any specific team setup, etc. This allows for multiple teams to be set up under a fleet project independantly. Importantly, it also allows for teams to be torn down without coordinating affecting the critical fleet project.



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


