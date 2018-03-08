## Get rook up and running
```console
kubectl create -f /vagrant/manifests/rook/rook-operator.yaml
kubectl create -f /vagrant/manifests/rook/rook-cluster.yaml
```

## Use tools to check on things
```console
kubectl create -f /vagrant/manifests/rook/rook-tools.yaml
kubectl -n rook exec -it rook-tools bash
```
[Toolbox Docs](https://rook.io/docs/rook/master/toolbox.html)

## Creating some storage
To create block storage we need a pool and a storage class
```
kubectl create -f /vagrant/manifests/rook/rook-pool.yaml
kubectl create -f /vagrant/manifests/rook/rook-storage.yaml
```

## TODO
- seeing some clock skew from `ceph -s`, need to look at how to deal with that
