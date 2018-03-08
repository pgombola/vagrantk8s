# About

Contains a vagrant environment that will start a Kubernetes cluster and manifests to deploy  Rook that is used for storage of CockroachDB data.

## Prerequisites
- VirtualBox
- Vagrant

## Getting Started

The environment only runs a single control plane. The number of nodes in the cluster is specified by setting the `WORKERS` variable. For instance, to start a Kubernetes cluster with 3 nodes:

```
WORKERS=3 vagrant up
```