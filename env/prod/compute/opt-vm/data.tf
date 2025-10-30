data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "credissuer-tf-state"
    key    = "env/prod/network/credissure/terraform.tfstate"
    region = "ap-south-1"
  }
}



