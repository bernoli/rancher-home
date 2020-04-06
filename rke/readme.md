# RKE setup @home

Setup:

```
rke up --config cluster.yml
./postcluster.sh
```

## Features

- Encryption at rest (https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/) 

```yaml
  kube-api:
    secrets_encryption_config:
      enabled: true
```

- etcd snapshots

```yaml
services:
  etcd-snapshot:
    retention: 3d
    interval_hours: 1h
```

- Ephemeral containers

```yaml
services:
  kube-controller:
    extra_args:
      feature-gates: "EphemeralContainers=true"
```

- Extra SNI

```yaml
authentication:
    strategy: x509
    sans:
      - "nas.stackmasters.com"
```

To Do:
- Azure AAD authentication
