############################################
# routes-private.tf — AZ-keyed maps
############################################

# ---------- APP PRIVATE ASSOCIATIONS ----------

# SINGLE mode: associate all app subnets to the shared app-private route table
resource "aws_route_table_association" "private_app_assoc_shared" {
  for_each       = var.nat_mode == "single" ? aws_subnet.private_app : {}
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_app_shared[0].id
}

# PER_AZ mode: associate each app subnet to its per-AZ route table
resource "aws_route_table_association" "private_app_assoc_per_az" {
  for_each       = var.nat_mode == "per_az" ? aws_subnet.private_app : {}
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_app_per_az[each.key].id
}


# ---------- DB PRIVATE ASSOCIATIONS ----------
# Common lab pattern: DB subnets have NO 0.0.0.0/0 route.
# They can still have their own route table (local VPC routes are implicit).

resource "aws_route_table" "private_db" {
  for_each = aws_subnet.private_db
  vpc_id   = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-db-private-rt-${each.key}"
  })
}

resource "aws_route_table_association" "private_db_assoc" {
  for_each       = aws_subnet.private_db
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_db[each.key].id
}