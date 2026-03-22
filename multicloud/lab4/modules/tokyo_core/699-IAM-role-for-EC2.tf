resource "aws_iam_policy" "ec2_s3_read_photos" {
  name = "${var.project_name}-ec2-s3-read-photos"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject"
      ]
      Resource = "${local.staff_photos_bucket_arn}/*"
    }]
  })
}