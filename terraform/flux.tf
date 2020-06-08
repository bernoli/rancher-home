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
  metadata {
    name = "fluxcd"
  }
}

resource "helm_release" "flux" {
  name       = "flux"
  repository = "https://charts.fluxcd.io"
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
    name  = "syncGarbageCollection.enabled"
    value = "true"
  }
}

resource "helm_release" "helmoperator_crds" {
  name       = "helmoperator_crds"
  repository = "../charts/helmoperator_crds"
  chart      = "helmoperator_crds"
  version    = "0.1.0"
}

resource "helm_release" "helm-operator" {

  depends_on = [
    helm_release.helmoperator_crds,
  ]

  name       = "helm-operator"
  repository = data.helm_repository.flux.metadata[0].name
  namespace  = "fluxcd"
  chart      = "fluxcd/helm-operator"
  version    = "1.3.0"

  set {
    name  = "helm.versions"
    value = "3"
  }

  set {
    name  = "configureRepositories.repositories[0].url"
    value = "https://kubernetes-charts.storage.googleapis.com"
  }

  set {
    name  = "configureRepositories.repositories[0].name"
    value = "stable"
  }


  set {
    name  = "configureRepositories.enable"
    value = "true"
  }

  set {
    name  = "git.ssh.secretName"
    value = "flux-git-deploy"
  }

}
