#VPC
resource "aws_vpc" "securecart-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

tags = {
  Name = "securecart-vpc"
}
}

#subnet
resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.securecart-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.securecart-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.securecart-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.securecart-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-2"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "securecart-igw" {
  vpc_id = aws_vpc.securecart-vpc.id

  tags = {
    Name = "securecart-igw"
  }
}

#NAT Gateway
resource "aws_nat_gateway" "securecart-nat" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "securecart-nat"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.securecart-igw, aws_eip.nat-eip]
}

#EIP
resource "aws_eip" "nat-eip" {
  domain   = "vpc"

  lifecycle {
    create_before_destroy = true
  }
}

#Route Tables
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.securecart-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.securecart-igw.id
    
  }

  tags = {
    Name = "public-rt"
  }
}

#Pub Subnet Association
resource "aws_route_table_association" "rtb1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "rtb2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.securecart-vpc.id

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route" "private_nat_gateway_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.securecart-nat.id
}

resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private_rt.id
}



