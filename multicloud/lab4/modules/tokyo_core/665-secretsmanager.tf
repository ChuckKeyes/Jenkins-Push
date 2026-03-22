############################################
# 65-secretsmanager.tf — create DB secret
############################################

# db_secret_name must be set (non-null) to create the secret
resource "aws_secretsmanager_secret" "db" {
  count = var.db_secret_name != null ? 1 : 0
  name  = var.db_secret_name
  tags  = var.tags
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db" {
  count     = var.db_secret_name != null ? 1 : 0
  secret_id = aws_secretsmanager_secret.db[0].id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}

locals {
  db_secret_json    = var.db_secret_name != null ? jsondecode(aws_secretsmanager_secret_version.db[0].secret_string) : {}
  final_db_username = var.db_secret_name != null ? local.db_secret_json.username : var.db_username
  final_db_password = var.db_secret_name != null ? local.db_secret_json.password : var.db_password
}