#
############################################
# NAT Gateway (single NAT)
############################################

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-nat-eip"
    }
  )
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[var.azs[0]].id

  depends_on = [aws_internet_gateway.this]

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-nat"
    }
  )
}

############################################
# Private App Route Table
############################################

resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-private-app-rt"
    }
  )
}

resource "aws_route" "private_app_default" {
  route_table_id         = aws_route_table.private_app.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

############################################
# Private App Route Table Associations
############################################

resource "aws_route_table_association" "private_app" {
  for_each = aws_subnet.private_app

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_app.id
}