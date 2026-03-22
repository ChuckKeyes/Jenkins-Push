locals {
  igw_name = "${var.vpc_name}-igw"

  public_subnet_names = [
    "${var.vpc_name}-public-az1",
    "${var.vpc_name}-public-az2",
  ]

  private_app_subnet_names = [
    "${var.vpc_name}-app-private-az1",
    "${var.vpc_name}-app-private-az2",
  ]

  private_db_subnet_names = [
    "${var.vpc_name}-db-private-az1",
    "${var.vpc_name}-db-private-az2",
  ]
}

locals {
  app_fqdn = "${var.app_subdomain}.${var.domain_name}"
  zone_id  = data.aws_route53_zone.primary.zone_id
}

data "aws_route53_zone" "primary" {
  name         = "${var.domain_name}."
  private_zone = false
}

# locals {
#   staff_photos_bucket_name = var.use_existing_staff_photos_bucket ? data.aws_s3_bucket.staff_photos_existing[0].bucket : aws_s3_bucket.staff_photos[0].bucket

#   staff_photos_bucket_id = var.use_existing_staff_photos_bucket ? data.aws_s3_bucket.staff_photos_existing[0].id : aws_s3_bucket.staff_photos[0].id
# }

