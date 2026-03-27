#Security Group for app
resource "aws_security_group" "securecart-sg" {
  name        = "securecart-sg"
  description = "Allow internal traffic for private instances"
  vpc_id      = aws_vpc.securecart-vpc.id

# Inbound: Allow SSH from within the VPC only
  /*ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.securecart-vpc.cidr_block]
  }*/

   ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion-sg.id]
  }

  # Outbound: Allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-sg"
  }
}



#Security Group for the ALB
resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = aws_vpc.securecart-vpc.id

  #Inbound HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Default Outbound (Allow All)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

 data "http" "my_ip" {
  url = "http://checkip.amazonaws.com/"
}

#Security Group for Bastion Host
resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg"
  #description = "Allow HTTP traffic to ALB"
  vpc_id      = aws_vpc.securecart-vpc.id

  #Inbound HTTP from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }

  #Default Outbound (Allow All)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}
