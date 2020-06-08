provider "helm" {
  kubernetes {
    host     = rke_cluster.cluster.api_server_url
    username = rke_cluster.cluster.kube_admin_user

    client_certificate     = rke_cluster.cluster.client_cert
    client_key             = rke_cluster.cluster.client_key
    cluster_ca_certificate = rke_cluster.cluster.ca_crt
  }
}

provider kubernetes {
  host     = rke_cluster.cluster.api_server_url
  username = rke_cluster.cluster.kube_admin_user

  client_certificate     = rke_cluster.cluster.client_cert
  client_key             = rke_cluster.cluster.client_key
  cluster_ca_certificate = rke_cluster.cluster.ca_crt
}

resource "kubernetes_namespace" "fluxcd" {
  name = "fluxcd"
}


data "helm_repository" "flux" {
  name = "flux"
  url  = "https://charts.fluxcd.io"
}

resource "helm_release" "flux" {
  name       = "flux"
  repository = data.helm_repository.flux.metadata[0].name
  namespace  = "fluxcd"
  chart      = "fluxcd/flux"
  version    = "1.3.0"

  set {
    name  = "git.url"
    value = "https://github.com/ams0/rancher-home.git"
  }

  set {
    name  = "git.readonly"
    value = "true"
  }

  set {
    name  = "sync.state"
    value = "secret"
  }


  set {
    name  = "git.path"
    value = "manifests"
  }

  set {
    name  = "git.pollInterval"
    value = "1m"
  }

  set {
    name  = "syncGarbageCollection"
    value = "true"
  }
}

resource "helm_release" "helmoperator_crds" {
  name  = "helmoperator_crdst"
  chart = "../charts/helmoperator_crds"
}
