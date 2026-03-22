# Explanation: Outputs are your mission report—what got built and where to find it.
output "ceklab1_vpc_id" {
  value = aws_vpc.ceklab1_vpc01.id
}

output "ceklab1_public_subnet_ids" {
  value = aws_subnet.ceklab1_public_subnets[*].id
}

output "ceklab1_private_subnet_ids" {
  value = aws_subnet.ceklab1_private_subnets[*].id
}

output "ceklab1_ec2_instance_id" {
  value = aws_instance.ceklab1_ec201.id
}

output "ceklab1_rds_endpoint" {
  value = aws_db_instance.ceklab1_rds01.address
}

output "ceklab1_sns_topic_arn" {
  value = aws_sns_topic.ceklab1_sns_topic01.arn
}

output "ceklab1_log_group_name" {
  value = aws_cloudwatch_log_group.ceklab1_log_group01.name
}

############################################
# Bonus A Outputs
############################################

# Proves private SSM connectivity (no public internet)
# output "bonus_a_vpce_ssm_id" {
#   description = "VPC Interface Endpoint ID for SSM"
#   value       = module.bonus_a.interface_endpoint_ids["ssm"]
# }

# # Proves private CloudWatch Logs connectivity
# output "bonus_a_vpce_logs_id" {
#   description = "VPC Interface Endpoint ID for CloudWatch Logs"
#   value       = module.bonus_a.interface_endpoint_ids["logs"]
# }

# # Proves private Secrets Manager connectivity
# output "bonus_a_vpce_secrets_id" {
#   description = "VPC Interface Endpoint ID for Secrets Manager"
#   value       = module.bonus_a.interface_endpoint_ids["secretsmanager"]
# }

# # Proves S3 access without NAT or IGW (gateway endpoint)
# output "bonus_a_vpce_s3_id" {
#   description = "VPC Gateway Endpoint ID for S3"
#   value       = module.bonus_a.s3_gateway_endpoint_id
# }

# # Proves EC2 is private (no public IP, SSM only)
# output "bonus_a_private_ec2_instance_id" {
#   description = "Private EC2 instance ID created by Bonus A"
#   value       = module.bonus_a.private_instance_id
# }

# # output "bonus_b_alb_dns_name" {
# #   value = module.ceklab1c_b.alb_dns_name
# # }

# output "bonus_b_app_fqdn" {
#   value = module.ceklab1c_b.app_fqdn
# }

# output "bonus_b_waf_arn" {
#   value = module.ceklab1c_b.waf_arn
# }

# output "bonus_b_alb_dns_name" {
#   value = module.ceklab1c_b.alb_dns_name
# }

# output "bonus_b_fqdn" {
#   value = "${var.app_subdomain}.${var.domain_name}"
# }