
#   providers = {
#     aws      = aws          # default region (Tokyo)
#     aws.use1 = aws.use1     # us-east-1 for CloudFront cert
#   }

#  variable "alb_dns_name" {
#   type = string
# }

# variable "domain_name" {
#   type = string
# }

# variable "app_subdomain" {
#   type    = string
#   default = "www"
# }

# variable "origin_header_name" {
#   type = string
# }

# variable "origin_header_value" {
#   type      = string
#   sensitive = true
# }

# locals {
#   app_fqdn = "${var.app_subdomain}.${var.domain_name}"
# }