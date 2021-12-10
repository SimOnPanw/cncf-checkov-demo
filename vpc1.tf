resource "aws_kms_key" "my_key" {
  description             = "KMS key for CloudWatch"
  deletion_window_in_days = 10
  tags = {
    yor_trace = "e8e021ab-a9fe-4b25-a099-198b940d5416"
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch-vpc-flowlog" {
  name              = "vpc-flowlog"
  retention_in_days = 14
  kms_key_id        = aws_kms_key.my_key.key_id
  tags = {
    yor_trace = "008ed892-de7c-401e-bf0a-1a87aa89e593"
  }
}

resource "aws_iam_role" "iam-vpc-flowlog" {
  name = "vpc-flowlog"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = {
    yor_trace = "ef1fa09b-289f-4403-a5d9-7f56bd08bde2"
  }
}

resource "aws_iam_role_policy" "role-vpc-flowlog" {
  name = "vpc-flowlog"
  role = aws_iam_role.iam-vpc-flowlog.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
# Create a VPC
resource "aws_vpc" "vpc1" {
  cidr_block           = var.cidr_blocks_vpc1
  enable_dns_hostnames = true
  enable_dns_support   = true
  //$TenantID-AWS-Development-VPC-01
  tags = {
    Name        = format("%s-AWS-%s-VPC00001", var.tenant, var.environment)
    Tenant      = var.tenant
    Environment = var.environment
    yor_trace   = "7a79ccfc-2eab-40b6-9ab1-2ae242d170bf"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    yor_trace = "1c4c31de-a830-4336-a0c2-09df2b459ddf"
  }
}

resource "aws_flow_log" "vpc-flowlog" {
  iam_role_arn    = aws_iam_role.iam-vpc-flowlog.arn
  log_destination = aws_cloudwatch_log_group.cloudwatch-vpc-flowlog.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc1.id
  tags = {
    yor_trace = "38356f52-8b66-416e-9701-e27a98676c17"
  }
}


resource "aws_internet_gateway" "vpc1_default" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name        = format("%s-AWS-%s-VPC00001-INTERNET-GATEWAY", var.tenant, var.environment)
    Tenant      = var.tenant
    Environment = var.environment
    yor_trace   = "4ffeca10-0cd7-4b45-9db9-d486ba9ccb2b"
  }
}

resource "aws_route_table" "vpc1_private_az1" {

  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name        = format("%s-AWS-%s-VPC00001-PRIVATE-ROUTE-TABLE-AZ1", var.tenant, var.environment)
    Tenant      = var.tenant
    Environment = var.environment
    yor_trace   = "422a6783-cbd1-42e7-9bae-0a412ed3f7e1"
  }
}
resource "aws_route_table" "vpc1_private_az2" {

  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name        = format("%s-AWS-%s-VPC00001-PRIVATE-ROUTE-TABLE-AZ2", var.tenant, var.environment)
    Tenant      = var.tenant
    Environment = var.environment
    yor_trace   = "4698838c-bd25-4845-87fa-ba125c5a355c"
  }
}

resource "aws_route" "vpc1_private_az1" {
  route_table_id         = aws_route_table.vpc1_private_az1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.vpc1_default_az1.id
}
resource "aws_route" "vpc1_private_az2" {
  route_table_id         = aws_route_table.vpc1_private_az2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.vpc1_default_az2.id
}

resource "aws_route_table" "vpc1_public" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name        = format("%s-AWS-%s-VPC00001-PUBLIC-ROUTE-TABLE", var.tenant, var.environment)
    Tenant      = var.tenant
    Environment = var.environment
    yor_trace   = "ce51c665-79ad-4842-9e6e-8cdd1f297bf0"
  }
}

resource "aws_route" "vpc1_public" {
  route_table_id         = aws_route_table.vpc1_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc1_default.id
}

# private subnets
resource "aws_subnet" "vpc1_private_az1" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.private_subnet_cidr_blocks_vpc1_az1
  availability_zone = var.az1

  tags = {
    Name        = format("%s-AWS-%s-VPC00001-PRIVATE-SUBNET-AZ1", var.tenant, var.environment)
    Tenant      = var.tenant
    Environment = var.environment
    yor_trace   = "f2994ac8-16b9-499b-a544-ac285bf19cf6"
  }
}
resource "aws_subnet" "vpc1_private_az2" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.private_subnet_cidr_blocks_vpc1_az2
  availability_zone = var.az2

  tags = {
    Name        = format("%s-AWS-%s-VPC00001-PRIVATE-SUBNET-AZ2", var.tenant, var.environment)
    Tenant      = var.tenant
    Environment = var.environment
    yor_trace   = "c79b24ab-5201-4235-ae84-e18132fe522c"
  }
}

resource "aws_route_table_association" "vpc1_private_az1" {
  subnet_id      = aws_subnet.vpc1_private_az1.id
  route_table_id = aws_route_table.vpc1_private_az1.id
}
resource "aws_route_table_association" "vpc1_private_az2" {
  subnet_id      = aws_subnet.vpc1_private_az2.id
  route_table_id = aws_route_table.vpc1_private_az2.id
}


# public subnets
resource "aws_subnet" "vpc1_public_az1" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.public_subnet_cidr_blocks_vpc1_az1
  availability_zone = var.az1

  tags = {
    Name        = format("%s-AWS-%s-VPC00001-PUBLIC-SUBNET-AZ1", var.tenant, var.environment)
    Tenant      = var.tenant
    Environment = var.environment
    yor_trace   = "b5476e62-93de-4b7a-8462-3dc1c8b3f4a5"
  }
}
resource "aws_subnet" "vpc1_public_az2" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.public_subnet_cidr_blocks_vpc1_az2
  availability_zone = var.az2

  tags = {
    Name        = format("%s-AWS-%s-VPC00001-PUBLIC-SUBNET-AZ2", var.tenant, var.environment)
    Tenant      = var.tenant
    Environment = var.environment
    yor_trace   = "f389ce24-9910-4f5a-9e91-af3963bf668d"
  }
}

resource "aws_route_table_association" "vpc1_public_az1" {
  subnet_id      = aws_subnet.vpc1_public_az1.id
  route_table_id = aws_route_table.vpc1_public.id
}

resource "aws_route_table_association" "vpc1_public_az2" {
  subnet_id      = aws_subnet.vpc1_public_az2.id
  route_table_id = aws_route_table.vpc1_public.id
}

resource "aws_eip" "vpc1_nat_az1" {
  vpc = true
  tags = {
    Name        = format("%s-AWS-%s-VPC00001-PUBLIC-IP-AZ1", var.tenant, var.environment)
    Tenant      = var.tenant
    Environment = var.environment
    yor_trace   = "cfe3969a-23ca-4542-87b5-8e530897ede7"
  }
}

resource "aws_eip" "vpc1_nat_az2" {
  vpc = true
  tags = {
    Name        = format("%s-AWS-%s-VPC00001-PUBLIC-IP-AZ2", var.tenant, var.environment)
    Tenant      = var.tenant
    Environment = var.environment
    yor_trace   = "69801e26-62ef-4b91-b038-5bf6bc7083fb"
  }
}

resource "aws_nat_gateway" "vpc1_default_az1" {
  depends_on = [aws_internet_gateway.vpc1_default]

  allocation_id = aws_eip.vpc1_nat_az1.id
  subnet_id     = aws_subnet.vpc1_public_az1.id

  tags = {
    Name        = format("%s-AWS-%s-VPC00001-NAT-GATEWAY-AZ1", var.tenant, var.environment)
    Tenant      = var.tenant
    Environment = var.environment
    yor_trace   = "0b6d52c9-07fa-4528-884a-b9edb5ad0b64"
  }
}

resource "aws_nat_gateway" "vpc1_default_az2" {
  depends_on = [aws_internet_gateway.vpc1_default]

  allocation_id = aws_eip.vpc1_nat_az2.id
  subnet_id     = aws_subnet.vpc1_public_az2.id

  tags = {
    Name        = format("%s-AWS-%s-VPC00001-NAT-GATEWAY-AZ2", var.tenant, var.environment)
    Tenant      = var.tenant
    Environment = var.environment
    yor_trace   = "29728c29-9f63-4b57-b74c-0e62e753f84e"
  }
}

