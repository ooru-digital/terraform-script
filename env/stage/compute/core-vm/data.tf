data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "credissuer-tf-state-bucket"
    key    = "env/staging/network-skeleton/credissure/terraform.tfstate"
    region = "ap-south-1"
  }
}

data "terraform_remote_state" "nginx_vm" {
  backend = "s3"
  config = {
    bucket = "credissuer-tf-state-bucket"
    key    = "env/staging/compute/nginx-proxy-vm/terraform.tfstate"
    region = "ap-south-1"
  }
}
