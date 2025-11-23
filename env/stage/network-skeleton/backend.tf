terraform {
  backend "s3" {
    bucket = "credissuer-tf-state"
    key    = "env/staging/network-skeleton/credissure/terraform.tfstate"
    region = "ap-south-1"
  }
}