resource "rke_cluster" "cluster" {

  cluster_name = "rancher-home"
  ssh_key_path = "/home/alessandro/.ssh/id_rsa"

  ignore_docker_version = true


  network {
    plugin = "canal"
  }

  ingress {
    provider = "none"
  }

  services {
    etcd {
      backup_config {
        retention      = "3d"
        interval_hours = "1h"
      }
    }
    kube-controller {
      extra_args = {
        feature-gates = "EphemeralContainers=true"
      }
    }

    scheduler {
      extra_args = {
        feature-gates = "EphemeralContainers=true"
      }
    }

    kubelet {
      max-pods = 250
      extra_args = {
        feature-gates = "EphemeralContainers=true"
      }
    }

    kube-api {
      secrets_encryption_config {
        enabled = true
      }
      extra_args = {
        feature-gates              = "EphemeralContainers=true"
        encryption-provider-config = "/etc/kubernetes/encryption.yaml"
        oidc-client-id             = "spn:5bd13b05-c17a-4589-8a61-f2185ab7831f"
        oidc-issuer-url            = "https://sts.windows.net/a68cdba5-68a4-49a3-8a42-2823316db54f/"
        oidc-username-claim        = "oid"
        oidc-groups-claim          = "groups"
      }
    }
  }

  nodes {
    address          = "cloud.stackmasters.com"
    internal_address = "192.168.178.2"
    user             = "alessandro"
    role             = ["controlplane", "etcd", "worker"]
    ssh_key_path     = "~/.ssh/id_rsa"

<<<<<<< HEAD
=======
    labels = {
      "node-role.kubernetes.io/master" = ""
    }
>>>>>>> 166dd5316308a1aeea1ab957dbc6bb9a7dc14b31
  }

  nodes {
    address          = "nuc1"
    internal_address = "192.168.178.5"
    user             = "alessandro"
    role             = ["worker"]
    ssh_key_path     = "~/.ssh/id_rsa"
  }

  nodes {
    address          = "nuc2"
    internal_address = "192.168.178.6"
    user             = "alessandro"
    role             = ["worker"]
    ssh_key_path     = "~/.ssh/id_rsa"
  }

  nodes {
    address          = "nuc1"
    internal_address = "192.168.178.9"
    user             = "alessandro"
    role             = ["worker"]
    ssh_key_path     = "~/.ssh/id_rsa"
  }

  authentication {
    strategy = "x509"
    sans = [
      "nas.stackmasters.com"
    ]
  }

  system_images {
    kubernetes = ["rancher/hyperkube:v1.18.3-rancher1"]
  }
}
