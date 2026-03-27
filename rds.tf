#RDS Subnet Group
resource "aws_db_subnet_group" "securecart-db-subnet-group" {
  name       = "securecart-db-subnet-group"
  #vpc_id     = aws_vpc.securecart-vpc.id
  subnet_ids = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]

  tags = {
    Name = "securecart-db-subnet-group"
  }
}

#RDS Instance
resource "aws_db_instance" "securecart-db" {
  identifier              = "securecart-db"
  engine                  = "mysql"
  engine_version          = "8.0"   
  instance_class          = "db.t3.micro"
  allocated_storage       = 20

  db_name                 = "securecart"
  username                = "admin"
  password                = "SecurePass123!"   # 🔐 Use secrets manager in real setup

  db_subnet_group_name    = aws_db_subnet_group.securecart-db-subnet-group.name
  vpc_security_group_ids  = [aws_security_group.securecart-rds-sg.id]

  publicly_accessible     = false
  skip_final_snapshot     = true
  multi_az                = false

  tags = {
    Name = "securecart-db"
  }
}

#RDS Security Group
resource "aws_security_group" "securecart-rds-sg" {
  name        = "securecart-rds-sg"
  description = "Allow DB access from private EC2"
  vpc_id      = aws_vpc.securecart-vpc.id

  ingress {
    description     = "MySQL from app EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.securecart-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "securecart-rds-sg"
  }
}

