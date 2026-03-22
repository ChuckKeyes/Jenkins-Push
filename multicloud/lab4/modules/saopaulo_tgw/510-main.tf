resource "aws_ec2_transit_gateway" "saopaulo_tgw" {
  provider = aws.saopaulo

  description                     = "Sao Paulo Transit Gateway - Armageddon Lab"
  amazon_side_asn                 = 64513
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = {
    Name = "saopaulo-tgw"
    Lab  = "Lab3"
  }
}

resource "aws_ec2_transit_gateway_route_table" "saopaulo_tgw_rt" {
  provider           = aws.saopaulo
  transit_gateway_id = aws_ec2_transit_gateway.saopaulo_tgw.id

  tags = {
    Name = "saopaulo-tgw-rt"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "saopaulo_vpc_attachment" {
  provider           = aws.saopaulo
  transit_gateway_id = aws_ec2_transit_gateway.saopaulo_tgw.id
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids

  tags = {
    Name = "saopaulo-vpc-to-tgw"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "saopaulo_assoc" {
  provider           = aws.saopaulo
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.saopaulo_vpc_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.saopaulo_tgw_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "saopaulo_propagation" {
  provider           = aws.saopaulo
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.saopaulo_vpc_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.saopaulo_tgw_rt.id
}

resource "aws_route" "saopaulo_to_tokyo" {
  provider           = aws.saopaulo
  route_table_id         = var.private_route_table_id
  destination_cidr_block = var.tokyo_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.saopaulo_tgw.id
}

# resource "aws_ec2_transit_gateway_route" "tokyo_network" {
#   provider           = aws.saopaulo
#   destination_cidr_block         = "10.10.0.0/16"
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.saopaulo_tgw_rt.id
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.saopaulo_vpc_attachment.id
# }