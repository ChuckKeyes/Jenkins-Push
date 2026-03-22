resource "aws_route" "tokyo_private_to_saopaulo" {
  provider               = aws
  for_each               = toset(module.tokyo_core.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = var.saopaulo_vpc_cidr
  transit_gateway_id     = module.tokyo_tgw.tgw_id
}