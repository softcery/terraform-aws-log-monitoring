terraform {
  required_providers {
    // main aws provider
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
