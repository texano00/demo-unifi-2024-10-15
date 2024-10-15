terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.71.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.6"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }

  required_version = "~> 1.9"
}