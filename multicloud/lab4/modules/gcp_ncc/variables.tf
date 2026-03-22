#
variable "project_id" {
  type = string
}

variable "hub_name" {
  type = string
}

variable "hub_description" {
  type    = string
  default = "GCP NCC hub for Iowa and NY connectivity"
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "iowa_network_uri" {
  type = string
}

variable "ny_network_uri" {
  type = string
}