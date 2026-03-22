locals {
  public_cidrs_by_az  = zipmap(var.azs, var.public_subnet_cidrs)
  app_cidrs_by_az     = zipmap(var.azs, var.private_app_subnet_cidrs)
  db_cidrs_by_az      = zipmap(var.azs, var.private_db_subnet_cidrs)
}

resource "aws_subnet" "public" {
  for_each                = toset(var.azs)
  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = local.public_cidrs_by_az[each.key]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-public-${each.key}"
    Tier = "public"
  })
}

resource "aws_subnet" "private_app" {
  for_each          = toset(var.azs)
  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  cidr_block        = local.app_cidrs_by_az[each.key]

  tags = merge(var.tags, {
    Name = "${var.project_name}-app-private-${each.key}"
    Tier = "private-app"
  })
}

resource "aws_subnet" "private_db" {
  for_each          = toset(var.azs)
  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  cidr_block        = local.db_cidrs_by_az[each.key]

  tags = merge(var.tags, {
    Name = "${var.project_name}-db-private-${each.key}"
    Tier = "private-db"
  })
}