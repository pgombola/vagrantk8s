# About

Contains a vagrant environment that will start a Kubernetes cluster and manifests to deploy  Rook that is used for storage of CockroachDB data.

## Prerequisites
- VirtualBox
- Vagrant

## Getting Started

The environment only runs a single control plane. The number of nodes in the cluster is specified by setting the `NODES` variable. For instance, to start a Kubernetes cluster with 3 nodes:

```
NODES=3 vagrant up
```

From here you can deploy [rook](manifests/rook), [cockroachdb](manifests/cockroachdb) and the [sample app](manifests/app).