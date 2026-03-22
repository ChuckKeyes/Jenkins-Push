variable "tokyo_tgw_id"      { type = string }
variable "customer_gw_ip_1"  { type = string }
variable "customer_gw_ip_2"  { type = string }
variable "customer_bgp_asn"  { type = number }
variable "tags" {
  type    = map(string)
  default = {}
}
variable "tokyo_tgw_route_table_id" {
  type = string
}