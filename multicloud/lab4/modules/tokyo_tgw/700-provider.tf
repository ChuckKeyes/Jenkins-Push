terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.34.0"
    }
  }
}

provider "aws" {
  alias  = "tokyo"
  region = "ap-northeast-1"
}