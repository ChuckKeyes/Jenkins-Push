#########################################################################


############################################
# Security Groups (EC2 + RDS)
############################################

# Explanation: EC2 SG is ceklab1’s bodyguard—only let in what you mean to.
############################################
# EC2 Security Group + EC2 Instance
############################################

resource "aws_security_group" "ceklab1_ec2_sg01" {
  name        = "${local.name_prefix}-ec2-sg01"
  description = "EC2 app security group"
  vpc_id      = aws_vpc.ceklab1_vpc01.id

  tags = {
    Name = "${local.name_prefix}-ec2-sg01"
  }
}

# Allow HTTP to the Flask app (port 80)
resource "aws_security_group_rule" "ceklab1_ec2_allow_http" {
  type              = "ingress"
  security_group_id = aws_security_group.ceklab1_ec2_sg01.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_instance" "ceklab1_ec201" {
  ami                   = var.ec2_ami_id
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.ceklab1_public_subnets[0].id
  vpc_security_group_ids = [aws_security_group.ceklab1_ec2_sg01.id]
  iam_instance_profile   = aws_iam_instance_profile.ceklab1_instance_profile01.name

  user_data = file("${path.module}/data.sh")

  tags = {
    Name = "${local.name_prefix}-ec201"
  }
}


# Allow MySQL ONLY from the app EC2 SG
############################################
# RDS (MySQL) + SG + Secret
############################################

resource "aws_security_group" "ceklab1_rds_sg01" {
  name        = "${local.name_prefix}-rds-sg01"
  description = "RDS security group"
  vpc_id      = aws_vpc.ceklab1_vpc01.id

  tags = {
    Name = "${local.name_prefix}-rds-sg01"
  }
}

# Allow MySQL ONLY from the EC2 SG
resource "aws_security_group_rule" "ceklab1_rds_allow_mysql_from_ec2" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ceklab1_ec2_sg01.id
  security_group_id        = aws_security_group.ceklab1_rds_sg01.id
}

resource "aws_db_subnet_group" "ceklab1_rds_subnet_group01" {
  name       = "${local.name_prefix}-rds-subnet-group01"
  subnet_ids = aws_subnet.ceklab1_private_subnets[*].id

  tags = {
    Name = "${local.name_prefix}-rds-subnet-group01"
  }
}

resource "aws_db_instance" "ceklab1_rds01" {
  identifier        = "${local.name_prefix}-rds01"
  engine            = var.db_engine
  instance_class    = var.db_instance_class
  allocated_storage = 20

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.ceklab1_rds_subnet_group01.name
  vpc_security_group_ids = [aws_security_group.ceklab1_rds_sg01.id]

  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name = "${local.name_prefix}-rds01"
  }
}

# IMPORTANT: your data.sh expects SECRET_ID=lab/rds/mysql (unless you changed it)


resource "aws_secretsmanager_secret_version" "ceklab1_db_secret_version01" {
  secret_id = aws_secretsmanager_secret.ceklab1_db_secret01.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    host     = aws_db_instance.ceklab1_rds01.address
    port     = aws_db_instance.ceklab1_rds01.port
    dbname   = var.db_name
  })
}

resource "aws_secretsmanager_secret" "ceklab1_db_secret01" {
  name = "lab/rds/mysql_v1"

  # lifecycle {
  #   prevent_destroy = true
  # }
}


############################################
# Secrets Manager (DB Credentials)
############################################

# Explanation: Secrets Manager is ceklab1’s locked holster—credentials go here, not in code.
# resource "aws_secretsmanager_secret" "ceklab1_db_secret01" {
#   name = "lab/rds/mysql-v9"
# }

# # Explanation: Secret payload—students should align this structure with their app (and support rotation later).
# resource "aws_secretsmanager_secret_version" "ceklab1_db_secret_version01" {
#   secret_id = aws_secretsmanager_secret.ceklab1_db_secret01.id

#   secret_string = jsonencode({
#     username = var.db_username
#     password = var.db_password
#     host     = aws_db_instance.ceklab1_rds01.address
#     port     = aws_db_instance.ceklab1_rds01.port
#     dbname   = var.db_name
#   })
# }


# Fix A — Restore the secret (us-east-1)

#aws secretsmanager restore-secret --region us-east-1 --secret-id lab/rds/mysql

#aws secretsmanager describe-secret --region us-east-1 --secret-id lab/rds/mysql \
##  --query "{Name:Name,DeletedDate:DeletedDate}" --output table

# terraform import aws_secretsmanager_secret.ceklab1_db_secret01 lab/rds/mysql

# aws secretsmanager describe-secret \
#   --region us-east-1 \
#   --secret-id lab/rds/mysql \
#   --query "ARN" \
#   --output text
# arn:aws:secretsmanager:us-east-1:557690581423:secret:lab/rds/mysql-vGsw6i

# terraform import aws_secretsmanager_secret.ceklab1_db_secret01 arn:aws:secretsmanager:us-east-1:557690581423:secret:lab/rds/mysql-vGsw6i

# aws_secretsmanager_secret.ceklab1_db_secret01: Importing from ID "arn:aws:secretsmanager:us-east-1:557690581423:secret:lab/rds/mysql-vGsw6i"...
# aws_secretsmanager_secret.ceklab1_db_secret01: Import prepared!
#   Prepared aws_secretsmanager_secret for import
# aws_secretsmanager_secret.ceklab1_db_secret01: Refreshing state... [id=arn:aws:secretsmanager:us-east-1:557690581423:secret:lab/rds/mysql-vGsw6i]

# Import successful!

# The resources that were imported are shown above. These resources are now in
# your Terraform state and will henceforth be managed by Terraform.
############################################################################################################

# Outputs:

# ceklab1_ec2_instance_id = "i-01fe2cc637bc0042b"
# ceklab1_log_group_name = "/aws/ec2/ceklab1-rds-app"
# ceklab1_private_subnet_ids = [
#   "subnet-09c37390bbf4f6749",
#   "subnet-08ea72a3f13574765",
# ]
# ceklab1_public_subnet_ids = [
#   "subnet-06cf993a458aac466",
#   "subnet-0bda83dae36317d1a",
# ]
# ceklab1_rds_endpoint = "ceklab1-rds01.cs3cu6i6843p.us-east-1.rds.amazonaws.com"
# ceklab1_sns_topic_arn = "arn:aws:sns:us-east-1:557690581423:ceklab1-db-incidents"
# ceklab1_vpc_id = "vpc-0f224e433ece68b74"

# SSM Session Manager

# aws ssm start-session --region us-east-1 --target i-01fe2cc637bc0042b

# ssh -i "Lab1c_keypair.pem" ec2-user@ec2-54-236-10-122.compute-1.amazonaws.com