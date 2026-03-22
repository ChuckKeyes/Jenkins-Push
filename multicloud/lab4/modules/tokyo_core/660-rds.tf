############################################
# Step 6 — RDS in private DB subnets
############################################

variable "db_engine" {
  type    = string
  default = "postgres"
}

variable "db_engine_version" {
  type    = string
  default = "17.6"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

# If you use Secrets Manager, you can omit db_password entirely.
variable "db_password" {
  description = "Only used if not using Secrets Manager"
  type        = string
  default     = null
  sensitive   = true
}

variable "db_port" {
  description = "Database port (Postgres=5432, MySQL=3306, etc.)"
  type        = number
  default     = 5432
}

variable "db_secret_name" {
  description = "Secrets Manager secret name containing JSON {username,password,dbname(optional)}"
  type        = string
  default     = null
}

# ---------- Subnet Group (private DB subnets) ----------
resource "aws_db_subnet_group" "db_subnets" {
  name       = "${var.project_name}-db-subnet-group-${substr(aws_vpc.this.id, -6, 6)}"
  subnet_ids = [for s in aws_subnet.private_db : s.id]

  tags = merge(var.tags, {
    Name = "${var.project_name}-db-subnet-group"
  })
}



# ---------- Optional: pull creds from Secrets Manager ----------
# data "aws_secretsmanager_secret" "db" {
#   count = var.db_secret_name != null ? 1 : 0
#   name  = var.db_secret_name
# }

# data "aws_secretsmanager_secret_version" "db" {
#   count     = var.db_secret_name != null ? 1 : 0
#   secret_id = data.aws_secretsmanager_secret.db[0].id
# }

# locals {
#   db_secret_json = var.db_secret_name != null ? jsondecode(data.aws_secretsmanager_secret_version.db[0].secret_string) : {}

#   final_db_username = var.db_secret_name != null ? local.db_secret_json.username : var.db_username
#   final_db_password = var.db_secret_name != null ? local.db_secret_json.password : var.db_password
# }

# ---------- RDS Instance ----------
resource "aws_db_instance" "db" {
  identifier = "${var.project_name}-db"

  engine         = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  allocated_storage = var.db_allocated_storage

  db_name  = var.db_name
  username = local.final_db_username
  password = local.final_db_password
  port     = var.db_port

  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false
  multi_az            = false

  storage_encrypted   = true
  skip_final_snapshot = true
  deletion_protection = false

  # Helpful for labs / frequent rebuilds
  apply_immediately = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-db"
    Role = "database"
  })
}