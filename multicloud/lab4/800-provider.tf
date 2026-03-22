terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.34.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "7.22.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "saopaulo"
  region = "sa-east-1"
}

provider "aws" {
  alias  = "tokyo"
  region = "ap-northeast-1"
}

provider "google" {
  project = "ck-armageddon"
  region  = var.gcp_region
}