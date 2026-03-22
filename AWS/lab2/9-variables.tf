############################################
# Bonus B - 9-variables.tf (CLEAN)
############################################

variable "project_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "target_instance_id" {
  type = string
}

variable "target_ec2_sg_id" {
  type = string
}

variable "target_port" {
  type    = number
  default = 80
}

variable "health_check_path" {
  type    = string
  default = "/"
}

############################################
# DNS / FQDN inputs (Route53 + ACM files use these)
############################################
variable "domain_name" {
  type = string
}

variable "app_subdomain" {
  type = string
}

# If true, create the Hosted Zone in this module.
# If false, we look up (or use) an existing hosted zone.
variable "manage_route53_in_terraform" {
  description = "If true, create the Hosted Zone in this module. If false, use existing hosted zone lookup/id."
  type        = bool
  default     = true
}

# Optional: only needed if you do NOT want to use data lookup by name
# (You can keep this; your locals can choose between data lookup vs explicit ID.)
variable "route53_hosted_zone_id" {
  description = "Existing Route53 Hosted Zone ID (used when manage_route53_in_terraform=false)."
  type        = string
  default     = ""
}

variable "certificate_validation_method" {
  description = "ACM validation method: DNS or EMAIL. DNS required for automated Route53 validation."
  type        = string
  default     = "DNS"
}

############################################
# HTTPS Listener dependency
############################################
# variable "acm_certificate_arn" {
#   description = "Validated ACM certificate ARN to attach to the ALB HTTPS listener."
#   type        = string
# }

variable "alb_ssl_policy" {
  description = "SSL policy for the ALB HTTPS listener."
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

############################################
# Optional: WAF
############################################
variable "enable_waf" {
  type    = bool
  default = true
}

# If you’re not using these yet, you can delete them.
variable "waf_log_destination" {
  type    = string
  default = "cloudwatch" # cloudwatch | s3 | firehose
}

variable "waf_log_retention_days" {
  type    = number
  default = 14
}

############################################
# Monitoring / Notifications
############################################
variable "sns_topic_arn" {
  type = string
}

variable "alb_5xx_threshold" {
  type    = number
  default = 1
}

variable "alb_5xx_period" {
  type    = number
  default = 300
}

variable "alb_5xx_eval_periods" {
  type    = number
  default = 1
}

############################################
# Optional: ALB access logs
############################################
variable "enable_alb_access_logs" {
  type    = bool
  default = false
}

variable "alb_access_logs_prefix" {
  type    = string
  default = "alb"
}
variable "enable_bonus_g" {
  type    = bool
  default = false
}
