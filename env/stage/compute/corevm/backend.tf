terraform {
  backend "s3" {
    bucket = "credissuer-tf-state"
    key    = "env/stage/compute/credissuer-core-vm/terraform.tfstate"
    region = "ap-south-1"
  }
}







