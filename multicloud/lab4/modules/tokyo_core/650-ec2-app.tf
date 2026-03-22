############################################
# Private EC2 App (SSM-managed) + TG attach
############################################

variable "app_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "app_ami_id" {
  description = "AMI in the same region (Tokyo). Use Amazon Linux 2 or AL2023."
  type        = string
}

# variable "app_port" {
#   description = "App port that ALB forwards to (nginx uses 80)"
#   type        = number
#   default     = 80
# }

# Pick which AZ's private app subnet to place the single instance in
variable "app_az" {
  description = "AZ key for the app instance subnet, must be one of var.azs"
  type        = string
}

# ---------- IAM for SSM ----------
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "app_ssm_role" {
  name               = "${var.project_name}-app-ssm-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(var.tags, { Name = "${var.project_name}-app-ssm-role" })
}

# Core SSM permissions (managed policy)
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.app_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "${var.project_name}-app-instance-profile"
  role = aws_iam_role.app_ssm_role.name
}


# data "aws_iam_policy_document" "app_s3_read" {
#   statement {
#     effect  = "Allow"
#     actions = ["s3:GetObject"]
#     resources = [
#       "arn:aws:s3:::${var.website_bucket}/*"
#     ]
#   }
# }

# resource "aws_iam_role_policy" "app_s3_read" {
#   name   = "${var.project_name}-app-s3-read"
#   role   = aws_iam_role.app_ssm_role.id
#   policy = data.aws_iam_policy_document.app_s3_read.json
# }







# ---------- EC2 ----------
resource "aws_instance" "app" {
  ami                    = var.app_ami_id
  instance_type          = var.app_instance_type
  subnet_id              = aws_subnet.private_app[var.app_az].id
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.app_instance_profile.name


user_data = <<-EOF
#!/bin/bash
set -euxo pipefail

dnf -y update
dnf -y install nginx awscli

# Pull website from S3
aws s3 cp s3://${var.website_bucket}/index.html /usr/share/nginx/html/index.html --region ${var.aws_region}

systemctl enable nginx
systemctl restart nginx
EOF
}
# ---------- Attach to ALB Target Group ----------
resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.app.id
  port             = var.app_port
}