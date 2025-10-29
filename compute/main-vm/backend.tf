terraform {
  backend "s3" {
    bucket = "credissuer-tf-state"
    key    = "env/testing/compute/credissuer-vm/terraform.tfstate"
    region = "ap-south-1"
  }
}

