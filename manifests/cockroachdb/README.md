## Apply the configs
```kubectl create -f /vagrant/manifests/cockroachdb/cockroacdb-statefulset-secure.yaml```

## Approve certificates
Each cockroachdb pod will request a certificate from kubernetes as part of an init-container.

```kubectl get csr```

Approve the certificates for each pod (replacing `<index>`) using:

```kubectl approve certificate default.node.cockroachdb-<index>```

## Initialize cluster
Next we'll run a job that will initialize the cockroachdb cluster. This will require approving another cert.

```
kubectl create -f /vagrant/manifests/cockroachdb/cluster-init-secure.yaml
kubectl certificate approve default.client.root
```