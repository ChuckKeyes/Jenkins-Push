data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "staff_photos_existing" {
  count  = var.use_existing_staff_photos_bucket ? 1 : 0
  bucket = var.existing_staff_photos_bucket_name
}

resource "aws_s3_bucket" "staff_photos" {
  count  = var.use_existing_staff_photos_bucket ? 0 : 1
  bucket = "${var.project_name}-staff-photos-${data.aws_caller_identity.current.account_id}"

  tags = merge(var.tags, {
    Name = "${var.project_name}-staff-photos"
  })
}

locals {


  staff_photos_bucket_id   = var.use_existing_staff_photos_bucket ? data.aws_s3_bucket.staff_photos_existing[0].id : aws_s3_bucket.staff_photos[0].id
  staff_photos_bucket_arn  = var.use_existing_staff_photos_bucket ? data.aws_s3_bucket.staff_photos_existing[0].arn : aws_s3_bucket.staff_photos[0].arn
  staff_photos_bucket_name = var.use_existing_staff_photos_bucket ? data.aws_s3_bucket.staff_photos_existing[0].bucket : aws_s3_bucket.staff_photos[0].bucket



  # staff_photos_bucket_id = var.use_existing_staff_photos_bucket
  #   ? data.aws_s3_bucket.staff_photos_existing[0].id
  #   : aws_s3_bucket.staff_photos[0].id

  # staff_photos_bucket_arn = var.use_existing_staff_photos_bucket
  #   ? data.aws_s3_bucket.staff_photos_existing[0].arn
  #   : aws_s3_bucket.staff_photos[0].arn

  # staff_photos_bucket_name = var.use_existing_staff_photos_bucket
  #   ? data.aws_s3_bucket.staff_photos_existing[0].bucket
  #   : aws_s3_bucket.staff_photos[0].bucket
}

resource "aws_s3_bucket_versioning" "staff_photos" {
  count  = var.use_existing_staff_photos_bucket ? 0 : 1
  bucket = local.staff_photos_bucket_id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "staff_photos" {
  count  = var.use_existing_staff_photos_bucket ? 0 : 1
  bucket = local.staff_photos_bucket_id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "staff_photos" {
  count  = var.use_existing_staff_photos_bucket ? 0 : 1
  bucket = local.staff_photos_bucket_id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

############################################
# IAM policy: EC2 can read/write staff photos
############################################

data "aws_iam_policy_document" "ec2_s3_staff_photos" {
  statement {
    sid    = "ListBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      local.staff_photos_bucket_arn
    ]
  }

  statement {
    sid    = "RWObjects"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${local.staff_photos_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "ec2_s3_staff_photos" {
  name   = "${var.project_name}-ec2-s3-staff-photos"
  policy = data.aws_iam_policy_document.ec2_s3_staff_photos.json

  tags = merge(var.tags, {
    Name = "${var.project_name}-ec2-s3-staff-photos"
  })
}

output "staff_photos_bucket_name" {
  value = local.staff_photos_bucket_name
}

output "staff_photos_bucket_arn" {
  value = local.staff_photos_bucket_arn
}