# Creates a RKE cluster
resource "rke_cluster" "cluster" {

  cluster_name = var.cluster-name
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
        retention      = "3"
        interval_hours = "12"
      }
    }
    kube_controller {
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
      extra_args = {
        feature-gates = "EphemeralContainers=true"
        max-pods = 250
      }
    }

    kube_api {
      secrets_encryption_config {
        enabled = true
      }
      extra_args = {
        feature-gates              = "EphemeralContainers=true"
       #encryption-provider-config = "/etc/kubernetes/encryption.yaml"
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
  }

  dynamic "nodes" {
    for_each = local.nodes

    content {
      address                 = nodes.key
      internal_address        = nodes.value
      user             = "alessandro"
      role             = ["worker"]
    }
  }

  authentication {
    strategy = "x509"
    sans = [
      "nas.stackmasters.com"
    ]
  }

  system_images {
    kubernetes = "rancher/hyperkube:v1.17.5-rancher1"
  }
}
