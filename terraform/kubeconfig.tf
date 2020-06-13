#Generates the admin kubeconfig 

resource "local_file" "kube_cluster_yaml" {
  filename = "kubeconfig.yaml"
  content  = rke_cluster.cluster.kube_config_yaml
}
