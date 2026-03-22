variable "vpc_id" {
  description = "São Paulo VPC ID to attach to the TGW"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for the São Paulo TGW attachment"
  type        = list(string)
}

variable "private_route_table_id" {
  description = "São Paulo private route table ID"
  type        = string
}

variable "tokyo_vpc_cidr" {
  description = "Tokyo VPC CIDR block"
  type        = string
}

