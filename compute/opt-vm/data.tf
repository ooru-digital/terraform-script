data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "credissuer-tf-state"
    key    = "env/testing/network-skeleton/network.tfstate"
    region = "ap-south-1"

  }
}



