A) Pre-reqs and decisions
0) Lock the “truth values” (write these down)

Tokyo VPC CIDR: (example 10.10.0.0/16)

São Paulo VPC CIDR: (example 10.20.0.0/16)

App subnets in SP: (example 10.20.10.0/24, 10.20.11.0/24)

DB port in Tokyo: 5432 (Postgres) or 3306 (MySQL)

Tokyo RDS SG ID / name and Tokyo RDS endpoint

1) Confirm Tokyo is stable

Tokyo TGW exists and attached to Tokyo VPC

Tokyo RDS is reachable from Tokyo EC2 (local check)

CloudFront → ALB → EC2 is working (you already have this)

B) São Paulo Terraform changes
2) Clone Lab2 “core”, remove DB

São Paulo builds “Lab2 minus DB”:

VPC (public/private subnets)

IGW + NAT

Route tables

ALB + target group + EC2/ASG (whatever your pattern is)

Security groups

Optional: same origin-header protections if you’re also fronting SP ALB with CloudFront later

São Paulo does NOT deploy:

RDS instance

DB subnet group

DB security group rules for local DB

DB alarms assuming local DB in-region

Outputs you must have from São Paulo core:

saopaulo_vpc_id

saopaulo_private_subnet_ids (2 subnets, 2 AZs)

saopaulo_private_route_table_ids (or one ID)

saopaulo_vpc_cidr

saopaulo_app_sg_id

C) TGW layer
3) Create São Paulo TGW (sa-east-1)

aws_ec2_transit_gateway in sa-east-1

aws_ec2_transit_gateway_route_table in sa-east-1

4) Attach São Paulo VPC to São Paulo TGW

aws_ec2_transit_gateway_vpc_attachment

use the private app subnets (two AZs)

Associate the attachment to SP TGW route table

Outputs from São Paulo TGW:

saopaulo_tgw_id

saopaulo_tgw_route_table_id

saopaulo_tgw_vpc_attachment_id

D) TGW peering (cross-region)
5) Create TGW peering: Tokyo ↔ São Paulo

Tokyo side (requester)

aws_ec2_transit_gateway_peering_attachment in ap-northeast-1

transit_gateway_id = tokyo_tgw_id

peer_transit_gateway_id = saopaulo_tgw_id

peer_region = "sa-east-1"

São Paulo side (accepter)

aws_ec2_transit_gateway_peering_attachment_accepter in sa-east-1

Outputs from peering:

tgw_peering_attachment_id

E) Routing (this is the “it works vs doesn’t” part)
6) Add TGW route-table routes (both TGWs)

This is the part many people miss.

Tokyo TGW route table

destination: São Paulo VPC CIDR

target: peering attachment

São Paulo TGW route table

destination: Tokyo VPC CIDR

target: peering attachment

7) Add VPC route-table routes (both VPCs)

São Paulo private route tables

destination: Tokyo VPC CIDR

target: São Paulo TGW ID

Tokyo private route tables

destination: São Paulo VPC CIDR

target: Tokyo TGW ID

F) Security groups for cross-region DB access
8) RDS SG rule in Tokyo (critical)

Because SG referencing doesn’t work cross-VPC the way you want:

Tokyo RDS SG

allow inbound on DB port (5432/3306)

from São Paulo app subnet CIDRs (best) or São Paulo VPC CIDR (acceptable for lab)

9) São Paulo app EC2 SG egress

allow outbound to Tokyo VPC CIDR on DB port

or just allow all egress (lab-simple)

G) DNS + app config
10) Ensure São Paulo app uses Tokyo RDS endpoint

Put Tokyo RDS endpoint into:

SSM Parameter Store (recommended), or

Secrets Manager (endpoint only), or

baked env var/user_data

Confirm:

VPC DNS support/hostnames enabled (defaults usually yes)

São Paulo instances resolve Tokyo RDS endpoint and can route to it

H) Testing checklist (do in this order)
11) Network-level tests

From a São Paulo EC2:

dig <tokyo-rds-endpoint> (should resolve)

nc -vz <tokyo-rds-endpoint> 5432 (or 3306)

traceroute optional (often not helpful with AWS)

12) App-level tests

run the app in SP and verify DB reads/writes

watch RDS connections in Tokyo metrics

I) Apply order (clean + predictable)

Tokyo core (already done)

Tokyo TGW (already done)

São Paulo core (new)

São Paulo TGW (new)

TGW peering (new)

Cross routes (new)

SG updates for Tokyo RDS (new)