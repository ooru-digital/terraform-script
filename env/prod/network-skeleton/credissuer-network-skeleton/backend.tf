terraform {
  backend "s3" {
    bucket = "credissuer-tf-state"
    key    = "env/stage/network/credissure/terraform.tfstate"
    region = "ap-south-1"
  }
}