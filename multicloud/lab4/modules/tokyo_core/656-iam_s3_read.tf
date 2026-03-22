data "aws_iam_policy_document" "app_s3_read" {
  statement {
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = [
      "arn:aws:s3:::${var.website_bucket}/*"
    ]
  }
}

resource "aws_iam_role_policy" "app_s3_read" {
  name   = "${var.project_name}-app-s3-read"
  role   = aws_iam_role.app_ssm_role.id
  policy = data.aws_iam_policy_document.app_s3_read.json
}