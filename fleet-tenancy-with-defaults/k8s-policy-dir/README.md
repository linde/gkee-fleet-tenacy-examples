
# gitops-minimal-network-policy
An example gitops repo that hosts a default deny NetworkPolicy for kubernetes. It is suitable for inclusion in [ConfigSync](https://cloud.google.com/anthos-config-management/docs/config-sync-overview) and takes advantage of its [NamespaceSelector](https://cloud.google.com/anthos-config-management/docs/how-to/namespace-scoped-objects#namespaceselectors_in_unstructured_repositories) functionality.


# Build and Publish

This chart uses github docs to host the repo.  To build and publish it, do the following, then commit and push:

```
helm package -d ../../docs/helm-repo  gkee-team-selector-example/
```