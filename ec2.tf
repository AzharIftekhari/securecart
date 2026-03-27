
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

