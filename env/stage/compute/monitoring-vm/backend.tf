terraform {
  backend "s3" {
    bucket = "credissuer-tf-state-bucket"
    key    = "env/staging/compute/monitoring-vm/terraform.tfstate"
    region = "ap-south-1"
  }
}







