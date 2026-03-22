#################################################
#1) Cache policy for static content (aggressive)
#################################################
resource "aws_cloudfront_cache_policy" "cache_static01" {
  name        = "${var.project_name}-cache-static01"
  comment     = "Aggressive caching for /static/*"
  default_ttl = 86400        # 1 day
  max_ttl     = 31536000     # 1 year
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config       { cookie_behavior = "none" }
    query_strings_config { query_string_behavior = "none" }
    headers_config       { header_behavior = "none" }

    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true
  }
}

#################################################
#2) Cache policy for API / dynamic (caching disabled)
#################################################
resource "aws_cloudfront_cache_policy" "cache_api_disabled01" {
  name        = "${var.project_name}-cache-api-disabled01"
  comment     = "Disable caching for dynamic content by default"
  default_ttl = 0
  max_ttl     = 0
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config       { cookie_behavior = "none" }
    query_strings_config { query_string_behavior = "none" }
# When TTL=0 (caching disabled), CloudFront rejects header allowlists in the cache policy.
headers_config { header_behavior = "none" }

    # enable_accept_encoding_gzip   = true
    # enable_accept_encoding_brotli = true
  }
}

#################################################
#3) Origin request policy for API/dynamic
#################################################
resource "aws_cloudfront_origin_request_policy" "orp_api01" {
  name    = "${var.project_name}-orp-api01"
  comment = "Forward necessary values for dynamic requests"

  cookies_config       { cookie_behavior = "all" }
  query_strings_config { query_string_behavior = "all" }

  headers_config {
    header_behavior = "whitelist"
    headers { items = ["Content-Type", "Origin", "Host"] }
  }
}

#################################################
#4) Origin request policy for static (minimal)
#################################################
resource "aws_cloudfront_origin_request_policy" "orp_static01" {
  name    = "${var.project_name}-orp-static01"
  comment = "Minimal forwarding for static assets"

  cookies_config       { cookie_behavior = "none" }
  query_strings_config { query_string_behavior = "none" }
  headers_config       { header_behavior = "none" }
}

#################################################
#5) Response headers policy (optional but nice)
#################################################
resource "aws_cloudfront_response_headers_policy" "rsp_static01" {
  name    = "${var.project_name}-rsp-static01"
  comment = "Add explicit Cache-Control for static content"

  custom_headers_config {
    items {
      header   = "Cache-Control"
      override = true
      value    = "public, max-age=86400, immutable"
    }
  }
}