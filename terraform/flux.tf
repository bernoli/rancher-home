provider "helm" {
  kubernetes {
    load_config_file = "false"


    host     = rke_cluster.cluster.api_server_url
    username = rke_cluster.cluster.kube_admin_user

    client_certificate     = rke_cluster.cluster.client_cert
    client_key             = rke_cluster.cluster.client_key
    cluster_ca_certificate = rke_cluster.cluster.ca_crt
  }
}

provider kubernetes {
  load_config_file = "false"


  host     = rke_cluster.cluster.api_server_url
  username = rke_cluster.cluster.kube_admin_user

  client_certificate     = rke_cluster.cluster.client_cert
  client_key             = rke_cluster.cluster.client_key
  cluster_ca_certificate = rke_cluster.cluster.ca_crt
}

resource "kubernetes_namespace" "fluxcd" {
  metadata {
    name = "fluxcd"
  }
}

resource "kubernetes_secret" "flux-ssh" {
  metadata {
    name      = "flux-ssh"
    namespace = kubernetes_namespace.fluxcd.metadata.0.name
  }
  data = {
    identity = tls_private_key.flux-deploy-key.private_key_pem
  }
}

resource "helm_release" "flux" {
  name       = "flux"
  repository = "https://charts.fluxcd.io"
  namespace  = "fluxcd"
  chart      = "flux"

#https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each/
  dynamic "set" {
    for_each = local.flux_values

    content {
      name                 = set.key
      value               = set.value
    }
  }
}

resource "helm_release" "helmoperatorcrds" {
  name       = "helmoperatorcrds"
  repository = "../charts/"
  chart      = "helmoperatorcrds"
}

resource "helm_release" "helm-operator" {

  depends_on = [
    helm_release.helmoperatorcrds,
  ]

  name       = "helm-operator"
  repository = "https://charts.fluxcd.io"
  namespace  = "fluxcd"
  chart      = "helm-operator"

#https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each/
  dynamic "set" {
    for_each = local.helmoperator_values

    content {
      name                 = set.key
      value               = set.value
    }
  }
}
