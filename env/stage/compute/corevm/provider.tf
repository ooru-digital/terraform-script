provider "aws" {
  region = var.region
  default_tags {
    tags = {
      "owner"      = "devops"
      "env"        = "stage"
      "managed-by" = "terraform"
      "vertical"   = "ooru"
    }
  }
}
