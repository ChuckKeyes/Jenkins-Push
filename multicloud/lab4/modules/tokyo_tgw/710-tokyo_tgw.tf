resource "aws_ec2_transit_gateway" "tokyo_tgw" {
  provider = aws.tokyo

  description                     = "Tokyo Transit Gateway - Armageddon Lab"
  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = {
    Name = "tokyo-tgw"
    Lab  = "Lab3"
  }
}

resource "aws_ec2_transit_gateway_route_table" "tokyo_tgw_rt" {
  provider           = aws.tokyo
  transit_gateway_id = aws_ec2_transit_gateway.tokyo_tgw.id

  tags = {
    Name = "tokyo-tgw-rt"
  }
}


resource "aws_ec2_transit_gateway_vpc_attachment" "tokyo_vpc_attachment" {
  provider = aws.tokyo

  transit_gateway_id = aws_ec2_transit_gateway.tokyo_tgw.id

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  tags = {
    Name = "tokyo-vpc-to-tgw"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "tokyo_assoc" {
  provider = aws.tokyo

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tokyo_vpc_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tokyo_tgw_rt.id
}

# resource "aws_ec2_transit_gateway_route" "tokyo_to_saopaulo_route" {
#   provider                       = aws
#   transit_gateway_route_table_id = module.tokyo_tgw.tgw_route_table_id
#   destination_cidr_block         = "10.20.0.0/16"
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tokyo_to_saopaulo.id
# }