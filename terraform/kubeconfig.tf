resource "local_file" "kube_cluster_yaml" {
  filename = "kubeconfig.yaml"
  content  = module.cluster[0].kube_config_yaml
}