# variable "tokyo_tgw_id" {
#   type = string
# }

# variable "tokyo_tgw_route_table_id" {
#   type = string
# }


variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "tokyo_tgw_id" {
  type = string
}

variable "tokyo_tgw_route_table_id" {
  type = string
}

variable "saopaulo_tgw_id" {
  type = string
}

variable "saopaulo_tgw_route_table_id" {
  type = string
}

variable "tokyo_vpc_cidr" {
  type = string
}

variable "saopaulo_vpc_cidr" {
  type = string
}