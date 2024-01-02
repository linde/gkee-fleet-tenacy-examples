
# gitops-minimal-network-policy

This directory hosts some example policy to show how could use [ConfigSync](https://cloud.google.com/anthos-config-management/docs/config-sync-overview) and  take advantage of its [NamespaceSelector](https://cloud.google.com/anthos-config-management/docs/how-to/namespace-scoped-objects#namespaceselectors_in_unstructured_repositories) functionality in a GKE Enterprise team context. 

## Examples #1 - a flat directory

The first example is a simple flat directory, [`policy`](./policy/), which has a multi-document yaml config. It's first resource is an example NamespaceSelector which will enable rendering of designated content that matches its label selector. The value for this selector matches the label GKE Enterprise applies to Fleet Namespaces within a Team. The second resource is an example NetworkPolicy that leverages the NamespaceSelector so that it will get rendered into any bound Fleet namespace.


## Examples #2 - A configurable helm chart

In the previous example, the value of the targetting team is baked into the config served via gitops.  This example is a bit more indirect, but shows a path for re-use across teams.

It provides [config to generate a helm chart](./gkee-team-selector-example/) with resources equivalent to the ones above, but with a configurable team name.

To see it in action, the config is packaged and served via github pages at this [helm repo](https://linde.github.io/gkee-fleet-tenacy-examples/helm-repo).  If you're making changes and want to package and publish it yourself, you can do the following and commit and push:

```
helm package -d ../../docs/helm-repo  gkee-team-selector-example/
```

A sample configsync rootsync for this repo would be:

```
apiVersion: configsync.gke.io/v1beta1
kind: RootSync
metadata:
  name: helm-root-sync
  namespace: config-management-system
spec:
  sourceType: helm
  sourceFormat: unstructured
  helm:
    auth: none
    repo: https://linde.github.io/gkee-fleet-tenacy-examples/helm-repo
    chart: gkee-team-selector-example
    version: 0.1.0
    releaseName: gkee-team-selector
    period: 1m
    values:
      gkeeTeamScopeId: acme-corp-products-team
```

You can change the value of the `gkeeTeamScopeId` to match your config.

