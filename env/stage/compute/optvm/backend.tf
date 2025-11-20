terraform {
  backend "s3" {
    bucket = "credissuer-tf-state"
    key    = "env/stage/compute/credissuer-opt-vm/terraform.tfstate"
    region = "ap-south-1"
  }
}

