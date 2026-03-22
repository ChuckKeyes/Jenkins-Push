############################################
# nat.tf — AZ-keyed maps (single | per_az)
# - public subnets:     aws_subnet.public[az]
# - private app subnets aws_subnet.private_app[az]
# - db subnets:         NO default route here
############################################

locals {
  nat_name = "${var.project_name}-nat"
  az0      = var.azs[0]
}

# ========== SINGLE MODE ==========
# One EIP + one NAT in the first AZ's public subnet
resource "aws_eip" "nat_shared" {
  count  = var.nat_mode == "single" ? 1 : 0
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${local.nat_name}-shared-eip"
  })
}

resource "aws_nat_gateway" "shared" {
  count         = var.nat_mode == "single" ? 1 : 0
  allocation_id = aws_eip.nat_shared[0].id
  subnet_id     = aws_subnet.public[local.az0].id

  tags = merge(var.tags, {
    Name = "${local.nat_name}-shared"
  })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "private_app_shared" {
  count  = var.nat_mode == "single" ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-app-private-rt-shared"
  })
}

resource "aws_route" "private_app_default_shared" {
  count                  = var.nat_mode == "single" ? 1 : 0
  route_table_id         = aws_route_table.private_app_shared[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.shared[0].id
}

# Associate ALL private_app subnets to the shared RT
# resource "aws_route_table_association" "private_app_assoc_shared" {
#   for_each       = var.nat_mode == "single" ? aws_subnet.private_app : {}
#   subnet_id      = each.value.id
#   route_table_id = aws_route_table.private_app_shared[0].id
# }

# ========== PER_AZ MODE ==========
# Per-AZ EIP/NAT in each public subnet (keyed by AZ)
resource "aws_eip" "nat_per_az" {
  for_each = var.nat_mode == "per_az" ? aws_subnet.public : {}
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${local.nat_name}-${each.key}-eip"
  })
}

resource "aws_nat_gateway" "per_az" {
  for_each      = var.nat_mode == "per_az" ? aws_subnet.public : {}
  allocation_id = aws_eip.nat_per_az[each.key].id
  subnet_id     = each.value.id

  tags = merge(var.tags, {
    Name = "${local.nat_name}-${each.key}"
  })

  depends_on = [aws_internet_gateway.this]
}

# One private APP route table per AZ (keyed by AZ)
resource "aws_route_table" "private_app_per_az" {
  for_each = var.nat_mode == "per_az" ? aws_subnet.private_app : {}
  vpc_id   = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-app-private-rt-${each.key}"
  })
}

resource "aws_route" "private_app_default_per_az" {
  for_each               = var.nat_mode == "per_az" ? aws_route_table.private_app_per_az : {}
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.per_az[each.key].id
}

# resource "aws_route_table_association" "private_app_assoc_per_az" {
#   for_each       = var.nat_mode == "per_az" ? aws_subnet.private_app : {}
#   subnet_id      = each.value.id
#   route_table_id = aws_route_table.private_app_per_az[each.key].id
# }