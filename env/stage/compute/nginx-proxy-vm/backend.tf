terraform {
  backend "s3" {
    bucket = "credissuer-tf-state-bucket"
    key    = "env/staging/compute/nginx-proxy-vm/terraform.tfstate"
    region = "ap-south-1"
  }
}



