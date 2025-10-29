provider "aws" {
  region = var.region
  default_tags {
    tags = {
      "owner"      = "devops"
      "env"        = "testing"
      "managed-by" = "terraform"
      "vertical"   = "ooru"
    }

  }
}
