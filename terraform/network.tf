
locals {
  environment = "dev"
  project     = "create-EC2"
  vpc_cidr    = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block                       = local.vpc_cidr
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${local.project}-${local.environment}-vpc"
    Project = local.project
    Env     = local.environment
  }
}

# Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = local.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name    = "${local.project}-${local.environment}-public-subnet"
    Project = local.project
    Env     = local.environment
    Type    = "public"
  }
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${local.project}-${local.environment}-rtb"
    Project = local.project
    Env     = local.environment
  }
}

# Route tableと subnetの関連付け
resource "aws_route_table_association" "public_rtb" {
  route_table_id = aws_route_table.rtb.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${local.project}-${local.environment}-igw"
    Project = local.project
    Env     = local.environment
  }
}

# Route tableとIGWの関連付け
resource "aws_route" "rtb_igw_route" {
  route_table_id         = aws_route_table.rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_security_group" "sg" {
  name   = "${local.project}-${local.environment}-sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${local.project}-${local.environment}-sg"
    Project = local.project
    Env     = local.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  from_port         = "22"
  to_port           = "22"
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.sg.id
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  ip_protocol       = "-1" // -1ですべての通信
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group" "http" {
  name   = "${local.project}-${local.environment}-http"
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${local.project}-${local.environment}-http"
    Project = local.project
    Env     = local.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "http_ingress" {
  from_port         = "80"
  to_port           = "80"
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.http.id
}

resource "aws_vpc_security_group_egress_rule" "http_egress" {
  ip_protocol       = "-1" // -1ですべての通信
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.http.id
}
