############################################
# nat.tf — simple & stable (single | per_az)
############################################

# ---- Locals ----
locals {
  name_prefix = var.project_name
  nat_name    = "${var.project_name}-nat"
}

# ========== SINGLE MODE ==========
# One EIP + one NAT in the first AZ's public subnet
resource "aws_eip" "nat_shared" {
  count  = var.nat_mode == "single" ? 1 : 0
  domain = "vpc"
  tags   = merge(var.tags, { Name = "${local.nat_name}-shared-eip" })
}

resource "aws_nat_gateway" "shared" {
  count         = var.nat_mode == "single" ? 1 : 0
  allocation_id = aws_eip.nat_shared[0].id
  subnet_id     = aws_subnet.public[var.azs[0]].id
  tags          = merge(var.tags, { Name = "${local.nat_name}-shared" })
  depends_on    = [aws_internet_gateway.this]
}

resource "aws_route_table" "private_shared" {
  count  = var.nat_mode == "single" ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${local.name_prefix}-private-rt-shared" })
}

resource "aws_route" "private_default_shared" {
  count                  = var.nat_mode == "single" ? 1 : 0
  route_table_id         = aws_route_table.private_shared[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.shared[0].id
}

resource "aws_route_table_association" "private_assoc_shared" {
  for_each      = var.nat_mode == "single" ? aws_subnet.private : {}
  subnet_id     = each.value.id
  route_table_id = aws_route_table.private_shared[0].id
}

# ========== PER_AZ MODE ==========
# Per-AZ EIP/NAT in each public subnet (keyed by AZ)
resource "aws_eip" "nat_per_az" {
  for_each = var.nat_mode == "per_az" ? aws_subnet.public : {}
  domain   = "vpc"
  tags     = merge(var.tags, { Name = "${local.nat_name}-${each.key}-eip" })
}

resource "aws_nat_gateway" "per_az" {
  for_each      = var.nat_mode == "per_az" ? aws_subnet.public : {}
  allocation_id = aws_eip.nat_per_az[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  tags          = merge(var.tags, { Name = "${local.nat_name}-${each.key}" })
  depends_on    = [aws_internet_gateway.this]
}

# One private RT per AZ (keyed by the same AZ as private subnets)
resource "aws_route_table" "private_per_az" {
  for_each = var.nat_mode == "per_az" ? aws_subnet.private : {}
  vpc_id   = aws_vpc.this.id
  tags     = merge(var.tags, { Name = "${local.name_prefix}-private-rt-${each.key}" })
}

resource "aws_route" "private_default_per_az" {
  for_each               = var.nat_mode == "per_az" ? aws_route_table.private_per_az : {}
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.per_az[each.key].id
}

resource "aws_route_table_association" "private_assoc_per_az" {
  for_each      = var.nat_mode == "per_az" ? aws_subnet.private : {}
  subnet_id     = each.value.id
  route_table_id = aws_route_table.private_per_az[each.key].id
}
