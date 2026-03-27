#key pair
resource "aws_key_pair" "securecart-key" {
  key_name = "securecart-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

#Bastion App
resource "tls_private_key" "bastion-instance-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion-key-pair" {
  key_name   = "bastion-instance-key"
  public_key = tls_private_key.bastion-instance-key.public_key_openssh
}

resource "local_file" "bastion_pem" {
  content  = tls_private_key.bastion-instance-key.private_key_pem
  filename = "bastion-instance-key.pem"
  file_permission = "0400"
}

#Instance_Public
resource "aws_instance" "bastion-host" {
  ami                     = "ami-02dfbd4ff395f2a1b"
  instance_type           = "t3.micro"
  subnet_id = aws_subnet.public-subnet-1.id  
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  key_name = aws_key_pair.bastion-key-pair.key_name

  tags = {
    Name = "bastion-host"
  }
}

#Securecart-App
resource "tls_private_key" "securecart-app-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "private-key-pair" {
  key_name   = "private-instance-key"
  public_key = tls_private_key.securecart-app-key.public_key_openssh
}

resource "local_file" "private-pem" {
  content  = tls_private_key.securecart-app-key.private_key_pem
  filename = "securecart-key.pem"
  file_permission = "0400"
}

#Instance_Private
resource "aws_instance" "securecart-app" {
  ami                         = "ami-02dfbd4ff395f2a1b"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private-subnet-1.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.securecart-sg.id]
  key_name = aws_key_pair.private-key-pair.key_name

  tags = {
    Name = "securecart-app"
  }
}

