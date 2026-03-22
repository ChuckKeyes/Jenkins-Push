resource "random_password" "origin_header_value" {
  length  = 32
  special = false
}

data "aws_iam_policy_document" "app_s3_read" {
  statement {
    effect = "Allow"
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.website_bucket}/*"]
  }
}

# resource "aws_iam_role_policy" "app_s3_read" {
#   name   = "${var.project_name}-app-s3-read"
#   role   = aws_iam_role.app_ssm_role.id
#   policy = data.aws_iam_policy_document.app_s3_read.json
# }

module "tokyo_core" {
  source = "./modules/tokyo_core"

  project_name = var.project_name
  vpc_name     = var.vpc_name
  vpc_cidr     = var.vpc_cidr

  azs                  = var.azs
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs

  tags = var.tags

  alb_acm_cert_arn   = var.alb_acm_cert_arn
  app_ami_id         = var.app_ami_id
  app_instance_type  = var.app_instance_type
  app_az             = var.app_az
  app_port           = var.app_port

  db_name        = var.db_name
  db_username    = var.db_username
  db_secret_name = var.db_secret_name
  db_port        = var.db_port
  db_password    = var.db_password

  origin_header_name  = var.origin_header_name
  origin_header_value = random_password.origin_header_value.result
   domain_name   = var.domain_name
  app_subdomain = var.app_subdomain

   website_bucket    = var.website_bucket
  website_index_key = var.website_index_key

}

#############################################################
module "edge_public" {
  source = "./modules/edge_public"

  providers = {
    aws      = aws
    aws.use1 = aws.use1
  }

  project_name = var.project_name
  tags                = var.tags

  alb_dns_name        = module.tokyo_core.alb_dns_name
  domain_name         = var.domain_name
  app_subdomain       = var.app_subdomain
  
  origin_header_name  = var.origin_header_name
  origin_header_value = random_password.origin_header_value.result
}

######################################################################

module "tokyo_tgw" {
  source = "./modules/tokyo_tgw"

  # providers = {
  #   aws = aws.tokyo

  # }

  vpc_id     = module.tokyo_core.vpc_id
  subnet_ids = module.tokyo_core.private_app_subnet_ids
}

module "saopaulo_core" {
  source = "./modules/saopaulo_core"

  providers = { aws = aws.saopaulo }

  project_name = "${var.project_name}-sp"
  vpc_name     = "saopaulo-vpc"

  # vpc vars here…
   vpc_cidr = var.saopaulo_vpc_cidr
  azs      = var.saopaulo_azs

  public_subnet_cidrs      = var.saopaulo_public_subnet_cidrs
  private_app_subnet_cidrs = var.saopaulo_private_app_subnet_cidrs

  app_ami_id        = var.saopaulo_app_ami_id
  app_instance_type = var.saopaulo_app_instance_type

  app_port = var.app_port

  tags = var.tags


}

#############################################################

module "saopaulo_tgw" {
  source = "./modules/saopaulo_tgw"

  providers = { aws = aws.saopaulo }

   vpc_id                 = module.saopaulo_core.vpc_id
  subnet_ids             = module.saopaulo_core.private_subnet_ids
  private_route_table_id = module.saopaulo_core.private_route_table_ids[0]
  tokyo_vpc_cidr         = var.tokyo_vpc_cidr
  
}

#################################################################

module "iowa_network" {
  source = "./modules/gcp_iowa_network"

  network_name = "iowa-medical-vpc"
  subnet_name  = "iowa-subnet"
  subnet_cidr  = var.iowa_subnet_cidr
  region       = var.gcp_region

  iowa_vpc_cidr = var.iowa_vpc_cidr
  ny_vpc_cidr   = var.ny_vpc_cidr
}

##################################################################

module "ny_network" {
  source = "./modules/gcp_ny_branch_network"

  network_name = "nihonmachi-ny-vpc"
  subnet_name  = "nihonmachi-subnet"
  subnet_cidr  = var.ny_subnet_cidr
  region       = var.gcp_region

  ny_vpc_cidr   = var.ny_vpc_cidr
  iowa_vpc_cidr = var.iowa_vpc_cidr
}
#########################################################################

module "peering_resources" {
  source = "./modules/peering_resources"

  providers = {
    aws             = aws
    aws.saopaulo    = aws.saopaulo
  }
  project_name                = var.project_name
  tags                        = var.tags
  tokyo_tgw_id                 = module.tokyo_tgw.tgw_id
  tokyo_tgw_route_table_id     = module.tokyo_tgw.tgw_route_table_id
  saopaulo_tgw_id              = module.saopaulo_tgw.saopaulo_tgw_id
  saopaulo_tgw_route_table_id  = module.saopaulo_tgw.saopaulo_tgw_route_table_id

  tokyo_vpc_cidr               = var.tokyo_vpc_cidr
  saopaulo_vpc_cidr            = var.saopaulo_vpc_cidr

  
}

################################################################################

module "gcp_ncc" {
  source = "./modules/gcp_ncc"

  project_id      = "ck-armageddon"
  hub_name        = "armageddon-ncc-hub"
  hub_description = "NCC hub for Iowa and NY to reach Tokyo Medical Center"

  labels = {
    project = "armageddon-lab3"
    owner   = "ck"
  }

   iowa_network_uri = var.iowa_network_uri
  ny_network_uri   = var.ny_network_uri
}

###############################################################################

module "gcp_transit_vpc" {
  source = "./modules/gcp_transit_vpc"

  project_id   = "ck-armageddon"
  network_name = "gcp-transit-vpc"
  subnet_name  = "gcp-transit-subnet-us-east1"
  region       = "us-east1"
  subnet_cidr  = "10.50.1.0/24"
}

#########################################################################

module "gcp_ha_vpn_to_aws" {
  source = "./modules/gcp_ha_vpn_to_aws"

  project_id           = "ck-armageddon"
  region               = "us-east1"
  network_id           = module.gcp_transit_vpc.network_id
  router_name          = "gcp-to-aws-router"
  ha_vpn_gateway_name  = "gcp-to-aws-ha-vpn"
  aws_external_gw_name = "aws-tokyo-external-gw"

  #  AWS gives/uses the actual public endpoints
  aws_peer_ip_1 = "18.180.228.239"
  aws_peer_ip_2 = "54.95.47.250"
  aws_peer_ip_3 = "18.180.5.230"
  aws_peer_ip_4 = "54.249.50.227"

  router_asn = 65010
}

#######################################################################

module "aws_tokyo_tgw_vpn" {
  source = "./modules/aws_tokyo_tgw_vpn"

  providers = {
    aws.tokyo = aws.tokyo
  }

  tokyo_tgw_id      = module.tokyo_tgw.tgw_id
  tokyo_tgw_route_table_id = module.tokyo_tgw.tgw_route_table_id
  customer_gw_ip_1  =  module.gcp_ha_vpn_to_aws.vpn_interface_0_ip
  customer_gw_ip_2  = module.gcp_ha_vpn_to_aws.vpn_interface_1_ip
  customer_bgp_asn  = 65010

  tags = {
    Project = "Armageddon-Lab3"
    Owner   = "CK"
  }
}