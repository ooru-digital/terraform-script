terraform {
  backend "s3" {
    bucket         = "credissuer-tf-state"
    key            = "env/testing/network-skeleton/network.tfstate"
    region         = "ap-south-1"
    # dynamodb_table = "terraform-dev-uat-state-locking"

  }
}
