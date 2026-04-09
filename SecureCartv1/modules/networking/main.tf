# ─────────────────────────────────────────────
# VPC
# ─────────────────────────────────────────────
resource "aws_vpc" "secure-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  # Enable DNS so EC2 instances get hostnames (required for RDS endpoint resolution)
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc-${var.environment}"
  }
}

# ─────────────────────────────────────────────
# Public Subnets
# ─────────────────────────────────────────────
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.secure-vpc.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-1-${var.environment}"
    Tier = "public"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.secure-vpc.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-2-${var.environment}"
    Tier = "public"
  }
}

# ─────────────────────────────────────────────
# Private Subnets
# ─────────────────────────────────────────────
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.secure-vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.az1

  tags = {
    Name = "${var.project_name}-private-subnet-1-${var.environment}"
    Tier = "private"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.secure-vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.az2

  tags = {
    Name = "${var.project_name}-private-subnet-2-${var.environment}"
    Tier = "private"
  }
}

# ─────────────────────────────────────────────
# Internet Gateway (for public subnets)
# ─────────────────────────────────────────────
resource "aws_internet_gateway" "secure-igw" {
  vpc_id = aws_vpc.secure-vpc.id

  tags = {
    Name = "${var.project_name}-igw-${var.environment}"
  }
}

# ─────────────────────────────────────────────
# Elastic IP for NAT Gateway
# ─────────────────────────────────────────────
resource "aws_eip" "nat" {
  domain = "vpc"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.project_name}-nat-eip-${var.environment}"
  }
}

# ─────────────────────────────────────────────
# NAT Gateway (placed in public-1 for HA baseline)
# ─────────────────────────────────────────────
resource "aws_nat_gateway" "secure-nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "${var.project_name}-nat-gw-${var.environment}"
  }

  depends_on = [aws_internet_gateway.secure-igw, aws_eip.nat]
}

# ─────────────────────────────────────────────
# Public Route Table → Internet Gateway
# ─────────────────────────────────────────────
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.secure-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secure-igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt-${var.environment}"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# ─────────────────────────────────────────────
# Private Route Table → NAT Gateway
# ─────────────────────────────────────────────
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.secure-vpc.id

  tags = {
    Name = "${var.project_name}-private-rt-${var.environment}"
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.secure-nat.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}
