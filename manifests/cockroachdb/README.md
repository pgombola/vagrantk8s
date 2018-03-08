## Apply the configs
```kubectl create -f /vagrant/manifests/cockroachdb/cockroacdb-statefulset-secure.yaml```

## Approve certificates
Each cockroachdb pod will request a certificate from kubernetes as part of an init-container.
```kubectl get csr```
Approve the certificates for each pod (replacing `<index>` using:
```kubectl approve certificate default.node.cockroachdb-<index>```