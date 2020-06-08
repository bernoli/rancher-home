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
  chart      = "flux"

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
  repository = "../charts/"
  chart      = "helmoperator_crds"
}

resource "helm_release" "helm-operator" {

  depends_on = [
    helm_release.helmoperator_crds,
  ]

  name       = "helm-operator"
  repository = "https://charts.fluxcd.io"
  namespace  = "fluxcd"
  chart      = "helm-operator"

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
