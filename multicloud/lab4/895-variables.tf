variable "project_name" { type = string }
variable "vpc_cidr"     { type = string }
variable "vpc_name"     { type = string }

variable "azs" { type = list(string) }

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_app_subnet_cidrs" {
  type = list(string)
}

variable "private_db_subnet_cidrs" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "alb_acm_cert_arn" { type = string }

variable "app_ami_id"        { type = string }
variable "app_instance_type" { type = string }
variable "app_az"            { type = string }
variable "app_port"          { type = number }

variable "db_name"        { type = string }
variable "db_username"    { type = string }
variable "db_secret_name" { type = string }
variable "db_port"        { type = number }

# NOTE: do NOT keep db_password in tfvars long-term.
# If your module still requires it, keep it for now, but migrate to Secrets Manager ASAP.
variable "db_password" {
  type      = string
  sensitive = true
}

variable "domain_name"   { type = string }
variable "app_subdomain" { type = string }

variable "origin_header_name" {
  type    = string
  default = "X-Origin-Verify"
}

variable "website_bucket" {
  description = "S3 bucket that stores index.html"
  type        = string
}

variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "website_index_key" {
  type        = string
  description = "S3 object key for index.html"
  default     = "index.html"
}

#####################################################################

variable "saopaulo_vpc_cidr" {
  type = string
}

variable "saopaulo_azs" {
  type = list(string)
}

variable "saopaulo_public_subnet_cidrs" {
  type = list(string)
}

# variable "saopaulo_private_subnet_cidrs" {
#   type = list(string)
# }

variable "saopaulo_private_app_subnet_cidrs" {
  type = list(string)
}

variable "saopaulo_app_ami_id" {
  type = string
}

variable "saopaulo_app_instance_type" {
  type = string
}

variable "tokyo_vpc_cidr" {
  description = "CIDR block for the Tokyo VPC"
  type        = string
}

variable "gcp_project_id" {
  description = "GCP project ID for Lab4"
  type = string
}

variable "gcp_region" {
  description = "Primary GCP region for Lab4"
  type    = string
  default = "us-central1"
}

variable "iowa_vpc_cidr" {
  type    = string
  default = "10.30.0.0/16"
}

variable "iowa_subnet_cidr" {
  type    = string
  default = "10.30.1.0/24"
}

variable "ny_vpc_cidr" {
  type    = string
  default = "10.40.0.0/16"
}

variable "ny_subnet_cidr" {
  type    = string
  default = "10.40.1.0/24"
}

variable "gcp_project" {
  description = "GCP project ID"
  type        = string
}

variable "project_id" {
  type    = string
  default = "ck-armageddon"
}

variable "iowa_network_uri" {
  type    = string
  default = "projects/ck-armageddon/global/networks/iowa-medical-vpc"
}

variable "ny_network_uri" {
  type    = string
  default = "projects/ck-armageddon/global/networks/nihonmachi-ny-vpc"
}