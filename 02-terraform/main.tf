provider "aws" {
  region              = var.region
  allowed_account_ids = [var.account_id]
  default_tags {
    tags = {
      ManagedBy = "terraform"
      "env"     = upper(var.env)
    }
  }
}

terraform {
  #   backend "s3" {
  #   }
}

locals {
  resource_prefix = "unifi-${var.env}-"
}