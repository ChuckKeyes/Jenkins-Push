#!/usr/bin/env bash
set -euo pipefail

TOKYO_REGION="ap-northeast-1"
SAOPAULO_REGION="sa-east-1"

echo "=================================================="
echo "LAB3 VERIFICATION"
echo "Tokyo <-> Sao Paulo TGW corridor"
echo "=================================================="
echo

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "ERROR: missing command: $1" >&2
    exit 1
  }
}

require_cmd aws

echo "== AWS Identity =="
aws sts get-caller-identity
echo

echo "== Tokyo VPCs =="
aws ec2 describe-vpcs \
  --region "$TOKYO_REGION" \
  --query 'Vpcs[].{VpcId:VpcId,Cidr:CidrBlock,Name:Tags[?Key==`Name`]|[0].Value}' \
  --output table
echo

echo "== Sao Paulo VPCs =="
aws ec2 describe-vpcs \
  --region "$SAOPAULO_REGION" \
  --query 'Vpcs[].{VpcId:VpcId,Cidr:CidrBlock,Name:Tags[?Key==`Name`]|[0].Value}' \
  --output table
echo

echo "== Tokyo EC2 Private IPs =="
aws ec2 describe-instances \
  --region "$TOKYO_REGION" \
  --query 'Reservations[].Instances[].{Name:Tags[?Key==`Name`]|[0].Value,InstanceId:InstanceId,PrivateIP:PrivateIpAddress,State:State.Name}' \
  --output table
echo

echo "== Sao Paulo EC2 Private IPs =="
aws ec2 describe-instances \
  --region "$SAOPAULO_REGION" \
  --query 'Reservations[].Instances[].{Name:Tags[?Key==`Name`]|[0].Value,InstanceId:InstanceId,PrivateIP:PrivateIpAddress,State:State.Name}' \
  --output table
echo

echo "== Tokyo RDS Endpoints =="
aws rds describe-db-instances \
  --region "$TOKYO_REGION" \
  --query 'DBInstances[].{DB:DBInstanceIdentifier,Engine:Engine,Endpoint:Endpoint.Address,Port:Endpoint.Port,Status:DBInstanceStatus}' \
  --output table
echo

echo "== Tokyo Transit Gateways =="
aws ec2 describe-transit-gateways \
  --region "$TOKYO_REGION" \
  --query 'TransitGateways[].{TGW:TransitGatewayId,State:State,Owner:OwnerId,Desc:Description}' \
  --output table
echo

echo "== Sao Paulo Transit Gateways =="
aws ec2 describe-transit-gateways \
  --region "$SAOPAULO_REGION" \
  --query 'TransitGateways[].{TGW:TransitGatewayId,State:State,Owner:OwnerId,Desc:Description}' \
  --output table
echo

echo "== TGW Peering Attachments (Tokyo view) =="
aws ec2 describe-transit-gateway-peering-attachments \
  --region "$TOKYO_REGION" \
  --query 'TransitGatewayPeeringAttachments[].{AttachmentId:TransitGatewayAttachmentId,State:State,RequesterTgw:RequesterTgwInfo.TransitGatewayId,RequesterRegion:RequesterTgwInfo.Region,AccepterTgw:AccepterTgwInfo.TransitGatewayId,AccepterRegion:AccepterTgwInfo.Region}' \
  --output table
echo

echo "== TGW Peering Attachments (Sao Paulo view) =="
aws ec2 describe-transit-gateway-peering-attachments \
  --region "$SAOPAULO_REGION" \
  --query 'TransitGatewayPeeringAttachments[].{AttachmentId:TransitGatewayAttachmentId,State:State,RequesterTgw:RequesterTgwInfo.TransitGatewayId,RequesterRegion:RequesterTgwInfo.Region,AccepterTgw:AccepterTgwInfo.TransitGatewayId,AccepterRegion:AccepterTgwInfo.Region}' \
  --output table
echo

echo "== Tokyo TGW VPC / Peering Attachments =="
aws ec2 describe-transit-gateway-attachments \
  --region "$TOKYO_REGION" \
  --query 'TransitGatewayAttachments[].{AttachmentId:TransitGatewayAttachmentId,Type:ResourceType,State:State,TransitGatewayId:TransitGatewayId,ResourceId:ResourceId}' \
  --output table
echo

echo "== Sao Paulo TGW VPC / Peering Attachments =="
aws ec2 describe-transit-gateway-attachments \
  --region "$SAOPAULO_REGION" \
  --query 'TransitGatewayAttachments[].{AttachmentId:TransitGatewayAttachmentId,Type:ResourceType,State:State,TransitGatewayId:TransitGatewayId,ResourceId:ResourceId}' \
  --output table
echo

echo "== Tokyo Route Tables =="
aws ec2 describe-route-tables \
  --region "$TOKYO_REGION" \
  --query 'RouteTables[].{RouteTableId:RouteTableId,VpcId:VpcId,Routes:Routes[*].DestinationCidrBlock}' \
  --output json
echo

echo "== Sao Paulo Route Tables =="
aws ec2 describe-route-tables \
  --region "$SAOPAULO_REGION" \
  --query 'RouteTables[].{RouteTableId:RouteTableId,VpcId:VpcId,Routes:Routes[*].DestinationCidrBlock}' \
  --output json
echo

echo "== Tokyo TGW Route Tables =="
aws ec2 describe-transit-gateway-route-tables \
  --region "$TOKYO_REGION" \
  --query 'TransitGatewayRouteTables[].{TGWRouteTableId:TransitGatewayRouteTableId,TransitGatewayId:TransitGatewayId,State:State,DefaultAssociation:DefaultAssociationRouteTable,DefaultPropagation:DefaultPropagationRouteTable}' \
  --output table
echo

echo "== Sao Paulo TGW Route Tables =="
aws ec2 describe-transit-gateway-route-tables \
  --region "$SAOPAULO_REGION" \
  --query 'TransitGatewayRouteTables[].{TGWRouteTableId:TransitGatewayRouteTableId,TransitGatewayId:TransitGatewayId,State:State,DefaultAssociation:DefaultAssociationRouteTable,DefaultPropagation:DefaultPropagationRouteTable}' \
  --output table
echo

echo "=================================================="
echo "NEXT MANUAL TESTS"
echo "=================================================="
echo "1. From Sao Paulo EC2:"
echo "   timeout 3 bash -c '</dev/tcp/<TOKYO-RDS-ENDPOINT>/3306' && echo CONNECTED"
echo
echo "2. From Sao Paulo EC2:"
echo "   curl -I http://localhost/"
echo
echo "3. From laptop:"
echo "   curl -I https://do920hzo448ns.cloudfront.net"
echo "   curl -I https://do920hzo448ns.cloudfront.net/images1.jpeg"
echo
echo "4. Architecture proof:"
echo "   CloudFront -> Sao Paulo compute -> TGW peering -> Tokyo DB"
echo "   PHI storage stays in Tokyo"
echo
echo "DONE"


################################################################################
##################################################################################
################################################################################

chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Lab3-Armageddon-new$ ./lab3_verify.sh
==================================================
LAB3 VERIFICATION
Tokyo <-> Sao Paulo TGW corridor
==================================================

== AWS Identity ==
{
    "UserId": "AIDAYDWHS6GXTCANQIJNY",
    "Account": "557690581423",
    "Arn": "arn:aws:iam::557690581423:user/AWSCLI"
}


== Tokyo VPCs ==
--------------------------------------------------------
|                     DescribeVpcs                     |
+----------------+-----------+-------------------------+
|      Cidr      |   Name    |          VpcId          |
+----------------+-----------+-------------------------+
|  10.10.0.0/16  |  vpc-lab3 |  vpc-0bdf995b96e939ccf  |
|  172.31.0.0/16 |  None     |  vpc-0f08193db2f851cd5  |
+----------------+-----------+-------------------------+


== Sao Paulo VPCs ==
------------------------------------------------------------
|                       DescribeVpcs                       |
+---------------+----------------+-------------------------+
|     Cidr      |     Name       |          VpcId          |
+---------------+----------------+-------------------------+
|  172.31.0.0/16|  None          |  vpc-09cf27100d151fff8  |
|  10.20.0.0/16 |  saopaulo-vpc  |  vpc-05758ad32619d5288  |
+---------------+----------------+-------------------------+


== Tokyo EC2 Private IPs ==
------------------------------------------------------------
|                     DescribeInstances                    |
+----------------------+-------+----------------+----------+
|      InstanceId      | Name  |   PrivateIP    |  State   |
+----------------------+-------+----------------+----------+
|  i-005d9228421708a97 |  None |  10.10.20.139  |  running |
+----------------------+-------+----------------+----------+


== Sao Paulo EC2 Private IPs ==
-----------------------------------------------------------------------
|                          DescribeInstances                          |
+----------------------+-------------------+---------------+----------+
|      InstanceId      |       Name        |   PrivateIP   |  State   |
+----------------------+-------------------+---------------+----------+
|  i-0e7cf8643dc26fdc6 |  lab3-vpc-sp-app  |  10.20.20.234 |  running |
+----------------------+-------------------+---------------+----------+


== Tokyo RDS Endpoints ==
---------------------------------------------------------------------------
|                           DescribeDBInstances                           |
+----------+--------------------------------------------------------------+
|  DB      |  lab3-vpc-db                                                 |
|  Endpoint|  lab3-vpc-db.ch24q2ss4jm0.ap-northeast-1.rds.amazonaws.com   |
|  Engine  |  postgres                                                    |
|  Port    |  5432                                                        |
|  Status  |  available                                                   |
+----------+--------------------------------------------------------------+


== Tokyo Transit Gateways ==
-----------------------------------------------------
|              DescribeTransitGateways              |
+-------+-------------------------------------------+
|  Desc |  Tokyo Transit Gateway - Armageddon Lab   |
|  Owner|  557690581423                             |
|  State|  available                                |
|  TGW  |  tgw-0eaa75951622fe79b                    |
+-------+-------------------------------------------+


== Sao Paulo Transit Gateways ==
---------------------------------------------------------
|                DescribeTransitGateways                |
+-------+-----------------------------------------------+
|  Desc |  Sao Paulo Transit Gateway - Armageddon Lab   |
|  Owner|  557690581423                                 |
|  State|  available                                    |
|  TGW  |  tgw-07b32e9d404c2db98                        |
+-------+-----------------------------------------------+


== TGW Peering Attachments (Tokyo view) ==

== TGW Peering Attachments (Sao Paulo view) ==

== Tokyo TGW VPC / Peering Attachments ==
------------------------------------------------------
|          DescribeTransitGatewayAttachments         |
+-------------------+--------------------------------+
|  AttachmentId     |  tgw-attach-036c5425b3752582b  |
|  ResourceId       |  vpc-0bdf995b96e939ccf         |
|  State            |  available                     |
|  TransitGatewayId |  tgw-0eaa75951622fe79b         |
|  Type             |  vpc                           |
+-------------------+--------------------------------+


== Sao Paulo TGW VPC / Peering Attachments ==
------------------------------------------------------
|          DescribeTransitGatewayAttachments         |
+-------------------+--------------------------------+
|  AttachmentId     |  tgw-attach-0b7519ce00fbe58bc  |
|  ResourceId       |  vpc-05758ad32619d5288         |
|  State            |  available                     |
|  TransitGatewayId |  tgw-07b32e9d404c2db98         |
|  Type             |  vpc                           |
+-------------------+--------------------------------+


== Tokyo Route Tables ==
[
    {
        "RouteTableId": "rtb-03162744f40ca9dc2",
        "VpcId": "vpc-0f08193db2f851cd5",
        "Routes": [
            "172.31.0.0/16",
            "0.0.0.0/0"
        ]
    },
    {
        "RouteTableId": "rtb-07fdb32fb8e071000",
        "VpcId": "vpc-0bdf995b96e939ccf",
        "Routes": [
            "10.10.0.0/16"
        ]
    },
    {
        "RouteTableId": "rtb-08583efda1cd453d4",
        "VpcId": "vpc-0bdf995b96e939ccf",
        "Routes": [
            "10.10.0.0/16"
        ]
    },
    {
        "RouteTableId": "rtb-09082a0b040b94dda",
        "VpcId": "vpc-0bdf995b96e939ccf",
        "Routes": [
            "10.10.0.0/16",
            "0.0.0.0/0"
        ]
    },
    {
        "RouteTableId": "rtb-0d3db5b8c7eb40214",
        "VpcId": "vpc-0bdf995b96e939ccf",
        "Routes": [
            "10.10.0.0/16",
            "0.0.0.0/0"
        ]
    },
    {
        "RouteTableId": "rtb-0f41996c25a784eaa",
        "VpcId": "vpc-0bdf995b96e939ccf",
        "Routes": [
            "10.10.0.0/16"
        ]
    }
]


== Sao Paulo Route Tables ==
[
    {
        "RouteTableId": "rtb-0ac876b6261526e4a",
        "VpcId": "vpc-05758ad32619d5288",
        "Routes": [
            "10.20.0.0/16",
            "0.0.0.0/0"
        ]
    },
    {
        "RouteTableId": "rtb-0b9adf136a97b22aa",
        "VpcId": "vpc-09cf27100d151fff8",
        "Routes": [
            "172.31.0.0/16",
            "0.0.0.0/0"
        ]
    },
    {
        "RouteTableId": "rtb-02cc1d9efeec450b1",
        "VpcId": "vpc-05758ad32619d5288",
        "Routes": [
            "10.10.0.0/16",
            "10.20.0.0/16",
            "0.0.0.0/0"
        ]
    },
    {
        "RouteTableId": "rtb-08b35f65284199d28",
        "VpcId": "vpc-05758ad32619d5288",
        "Routes": [
            "10.20.0.0/16"
        ]
    }
]


== Tokyo TGW Route Tables ==
-----------------------------------------------------
|         DescribeTransitGatewayRouteTables         |
+---------------------+-----------------------------+
|  DefaultAssociation |  False                      |
|  DefaultPropagation |  False                      |
|  State              |  available                  |
|  TGWRouteTableId    |  tgw-rtb-0793828a75706f478  |
|  TransitGatewayId   |  tgw-0eaa75951622fe79b      |
+---------------------+-----------------------------+


== Sao Paulo TGW Route Tables ==
-----------------------------------------------------
|         DescribeTransitGatewayRouteTables         |
+---------------------+-----------------------------+
|  DefaultAssociation |  False                      |
|  DefaultPropagation |  False                      |
|  State              |  available                  |
|  TGWRouteTableId    |  tgw-rtb-0fcf6103ee2779695  |
|  TransitGatewayId   |  tgw-07b32e9d404c2db98      |
+---------------------+-----------------------------+


==================================================
NEXT MANUAL TESTS
==================================================
1. From Sao Paulo EC2:
   timeout 3 bash -c '</dev/tcp/<TOKYO-RDS-ENDPOINT>/3306' && echo CONNECTED

2. From Sao Paulo EC2:
   curl -I http://localhost/

3. From laptop:
   curl -I https://do920hzo448ns.cloudfront.net
   curl -I https://do920hzo448ns.cloudfront.net/images1.jpeg

4. Architecture proof:
   CloudFront -> Sao Paulo compute -> TGW peering -> Tokyo DB
   PHI storage stays in Tokyo

DONE