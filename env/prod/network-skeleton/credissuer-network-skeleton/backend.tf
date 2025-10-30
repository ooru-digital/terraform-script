terraform {
  backend "s3" {
    bucket = "credissuer-tf-state"
    key    = "env/prod/network/credissure/terraform.tfstate"
    region = "ap-south-1"
  }
}