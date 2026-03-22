variable "domain_name" {
  description = "Base domain (example: keyescloudsolutions.com)"
  type        = string
}

variable "app_subdomain" {
  description = "Subdomain label (example: www)"
  type        = string
  default     = "www"
}

variable "alb_dns_name" {
  description = "Tokyo ALB DNS name used as CloudFront origin"
  type        = string
}

variable "origin_header_name" {
  description = "Header name CloudFront will send to ALB"
  type        = string
  default     = "X-Origin-Verify"
}

variable "project_name" {
  description = "Project/name prefix for resources (ex: lab2-vpc)"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "origin_header_value" {
  type      = string
  sensitive = true
}