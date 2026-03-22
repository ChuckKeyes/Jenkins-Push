############################################
# IAM policy: EC2 can read/write staff photos
############################################

# data "aws_iam_policy_document" "ec2_s3_staff_photos" {
#   statement {
#     sid    = "ListBucket"
#     effect = "Allow"
#     actions = [
#       "s3:ListBucket"
#     ]
  #   resources = [
  #     aws_s3_bucket.staff_photos.arn
  #   ]
  # }

#   statement {
#     sid    = "RWObjects"
#     effect = "Allow"
#     actions = [
#       "s3:GetObject",
#       "s3:PutObject",
#       "s3:DeleteObject"
#     ]
#     resources = [
#       "${aws_s3_bucket.staff_photos.arn}/*"
#     ]
#   }
# }

# resource "aws_iam_policy" "ec2_s3_staff_photos" {
#   name   = "${var.project_name}-ec2-s3-staff-photos"
#   policy = data.aws_iam_policy_document.ec2_s3_staff_photos.json

#   tags = merge(var.tags, {
#     Name = "${var.project_name}-ec2-s3-staff-photos"
#   })
# }

# output "staff_photos_bucket_name" {
#   value = aws_s3_bucket.staff_photos.bucket
# }

# output "staff_photos_bucket_arn" {
#   value = aws_s3_bucket.staff_photos.arn
# }

