############################################
# Step 10 — Secret origin header value
############################################

# variable "origin_header_name" {
#   description = "Header name CloudFront sends to ALB; ALB will require it"
#   type        = string
#   default     = "X-Origin-Verify"
# }

resource "random_password" "origin_header_value" {
  length  = 48
  special = false
}

