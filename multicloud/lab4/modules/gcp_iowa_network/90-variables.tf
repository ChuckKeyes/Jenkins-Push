variable "network_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "iowa_vpc_cidr" {
  type = string
}

variable "ny_vpc_cidr" {
  type = string
}