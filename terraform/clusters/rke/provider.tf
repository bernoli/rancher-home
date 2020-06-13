# tf 0.13 uses a different approach to plugin location
# create a folder and copy the rke provider in it: .terraform/plugins/terraform.example.com/rancher/rke/1.0.0/linux_amd64/terraform-provider-rke_1.0.0
# doesn't seem to work with ~/.terraform.d/plugins folder
# ref https://gist.github.com/mildwonkey/54ce5cf5283d9ea982d952e3c04a5956 https://gist.github.com/mildwonkey/85df0f0605880a0f08b6f05c15092bd7 https://www.hashicorp.com/blog/adding-provider-source-to-hashicorp-terraform/ 
terraform {
  required_providers {
    rke = {
      source  = "terraform.example.com/rancher/rke"
      version = "1.0.0"
    }
  }
}