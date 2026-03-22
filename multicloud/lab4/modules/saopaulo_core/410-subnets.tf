#
############################################
# Public Subnets
############################################

resource "aws_subnet" "public" {
  for_each = {
    for idx, az in var.azs :
    az => {
      az   = az
      cidr = var.public_subnet_cidrs[idx]
    }
  }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-public-${each.key}"
    }
  )
}

############################################
# Private App Subnets
############################################

resource "aws_subnet" "private_app" {
  for_each = {
    for idx, az in var.azs :
    az => {
      az   = az
      cidr = var.private_app_subnet_cidrs[idx]
    }
  }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-private-app-${each.key}"
    }
  )
}