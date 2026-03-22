# saopaulo_project_name
# saopaulo_vpc_cidr
# saopaulo_azs
# saopaulo_public_subnet_cidrs
# saopaulo_private_app_subnet_cidrs
# saopaulo_app_ami_id
# saopaulo_app_instance_type
# tags

# app_port

variable "project_name" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_app_subnet_cidrs" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "app_ami_id" {
  type = string
}

variable "app_instance_type" {
  type = string
}

variable "app_port" {
  description = "Application port used by the EC2 instance"
  type        = number
}