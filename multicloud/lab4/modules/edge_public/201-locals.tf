# data "aws_route53_zone" "primary" {
#   name         = "${var.domain_name}."
#   private_zone = false
# }

# locals {
#   zone_id  = data.aws_route53_zone.primary.zone_id
#   app_fqdn = "${var.app_subdomain}.${var.domain_name}"
# }

# locals {
#   app_fqdn = "${var.app_subdomain}.${var.domain_name}"
# }