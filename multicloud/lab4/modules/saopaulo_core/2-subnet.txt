# Calculate public and private subnets across AZs
locals {
  # First N public subnets
  public_cidrs = [
    for i in range(var.public_subnet_count) :
    cidrsubnet(var.vpc_cidr, var.subnet_newbits, i)
  ]

  # Start private subnets after the public ones
  private_cidrs = [
    for i in range(length(var.azs)) :
    cidrsubnet(var.vpc_cidr, var.subnet_newbits, i + var.public_subnet_count)
  ]
}

# ----------------------
# Public subnets
# ----------------------
resource "aws_subnet" "public" {
  # Build a map: AZ => { az, cidr }
  for_each = {
    for idx, az in var.azs :
    az => {
      az   = az
      cidr = local.public_cidrs[idx]
    } if idx < var.public_subnet_count
  }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    { Name = "${local.name}-public-${each.key}" }
  )
}

# ----------------------
# Private subnets
# ----------------------
resource "aws_subnet" "private" {
  # One private subnet per AZ (using local.private_cidrs)
  for_each = {
    for idx, az in var.azs :
    az => {
      az   = az
      cidr = local.private_cidrs[idx]
    } if idx < length(local.private_cidrs)
  }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    { Name = "${local.name}-private-${each.key}" }
  )
}
