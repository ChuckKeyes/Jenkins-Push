modules/saopaulo_compute

Purpose: São Paulo is compute-only (NO DB). 

3a_lab

 

Readme


Contains:

SP VPC + subnets + NAT/routing

ALB/ASG/EC2 app tier

CloudFront origin behavior bits if you’re doing it inside this stack

Outputs:

sp_vpc_id

sp_vpc_cidr

sp_private_route_table_ids

sp_app_sg_id

sp_tgw_name_prefix (optional)

liberdade_tgw_id = "tgw-0dee9825b3fbf81e7"
chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Lab3-Armageddon/Sao-Paulo$ aws ec2 describe-transit-gateway-peering-attachments \
>   --region sa-east-1 \
>   --query "TransitGatewayPeeringAttachments[?TransitGatewayAttachmentId=='tgw-attach-055259c3719027162'].{Id:TransitGatewayAttachmentId,State:State}" \
>   --output table
-----------------------------------------------
|  DescribeTransitGatewayPeeringAttachments   |
+-------------------------------+-------------+
|              Id               |    State    |
+-------------------------------+-------------+
|  tgw-attach-055259c3719027162 |  available  |
+-------------------------------+-------------+

chuck@LAPTOP-1B94MM1R:/d/New Obsidian/Armageddon-Lab1-2-3-4/Lab3-Armageddon/Sao-Paulo$ aws ec2 describe-transit-gateway-vpc-attachments \
>   --region sa-east-1 \
>   --query "TransitGatewayVpcAttachments[].{Id:TransitGatewayAttachmentId,VpcId:VpcId,State:State}" \
>   --output table
------------------------------------------------------------------------
|                 DescribeTransitGatewayVpcAttachments                 |
+-------------------------------+------------+-------------------------+
|              Id               |   State    |          VpcId          |
+-------------------------------+------------+-------------------------+
|  tgw-attach-0bb322a01d9ae42be |  available |  vpc-07d3adc5241ea7c0e  |
+-------------------------------+------------+-------------------------+