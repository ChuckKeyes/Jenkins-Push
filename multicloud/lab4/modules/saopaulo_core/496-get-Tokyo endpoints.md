Example set (good / clean):

São Paulo VPC CIDR: 10.20.0.0/16

São Paulo private app subnets (2 AZs):

10.20.10.0/24

10.20.11.0/24

(Optional public subnets, if you mirror Lab2)

10.20.0.0/24

10.20.1.0/24

Put these in your São Paulo tfvars later.

######################################################

Step 1B — Confirm Tokyo DB port

Pick one (based on your RDS engine):

Postgres: 5432

MySQL/MariaDB: 3306

aws rds describe-db-instances \
  --region ap-northeast-1 \
  --query "DBInstances[*].{ID:DBInstanceIdentifier,Engine:Engine,Port:Endpoint.Port}" \
  --output table

  #########################################################

  Step 1C — Get the Tokyo RDS endpoint

  aws rds describe-db-instances \
  --region ap-northeast-1 \
  --query "DBInstances[*].{ID:DBInstanceIdentifier,Endpoint:Endpoint.Address,Port:Endpoint.Port,VPC:DBSubnetGroup.VpcId}" \
  --output table

  ###########################################################

  Step 1D — Get the Tokyo RDS Security Group ID (this is what you’ll open to São Paulo CIDRs)
1) Grab the SG ID(s) attached to the DB:

aws rds describe-db-instances \
  --region ap-northeast-1 \
  --query "DBInstances[*].{ID:DBInstanceIdentifier,SGs:VpcSecurityGroups[*].VpcSecurityGroupId}" \
  --output table

  ############################################################

  2) Optional: Resolve the SG name from that SG ID

Replace sg-XXXXXXXX with the SG ID you got above:

aws ec2 describe-security-groups \
  --region ap-northeast-1 \
  --group-ids sg-XXXXXXXX \
  --query "SecurityGroups[*].{GroupId:GroupId,GroupName:GroupName,VpcId:VpcId}" \
  --output table

  ###################################################################

  Step 1E — Save these 4 outputs (this is your Step 1 deliverable)

You should end Step 1 with:

São Paulo VPC CIDR: 10.20.0.0/16

São Paulo app subnet CIDRs (2): 10.20.10.0/24, 10.20.11.0/24

Tokyo DB port: 5432 or 3306

Tokyo RDS:

Endpoint: xxxxx.ap-northeast-1.rds.amazonaws.com

RDS SG ID: sg-...