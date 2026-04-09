# ═══════════════════════════════════════════════════════════
#  Module: compute
#  Resources: TLS key pairs, AWS Key Pairs, local PEM files,
#             Bastion EC2 (public), App EC2 (private)
# ═══════════════════════════════════════════════════════════

resource "tls_private_key" "bastion" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion" {
  key_name   = "${var.project_name}-bastion-key-${var.environment}"
  public_key = tls_private_key.bastion.public_key_openssh

  tags = {
    Name = "${var.project_name}-bastion-key-${var.environment}"
  }
}

resource "local_file" "bastion_pem" {
  content         = tls_private_key.bastion.private_key_pem
  filename        = "${path.root}/${var.project_name}-bastion-${var.environment}.pem"
  file_permission = "0400"
}

# ─────────────────────────────────────────────
# Application Server – Key Pair
# ─────────────────────────────────────────────
resource "tls_private_key" "app" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "app" {
  key_name   = "${var.project_name}-app-key-${var.environment}"
  public_key = tls_private_key.app.public_key_openssh

  tags = {
    Name = "${var.project_name}-app-key-${var.environment}"
  }
}

resource "local_file" "app_pem" {
  content         = tls_private_key.app.private_key_pem
  filename        = "${path.root}/${var.project_name}-app-${var.environment}.pem"
  file_permission = "0400"
}

resource "aws_instance" "bastion" {
  ami                         = var.bastion_ami
  instance_type               = var.bastion_instance_type
  subnet_id                   = var.public_subnet_1_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.bastion_sg_id]
  key_name                    = aws_key_pair.bastion.key_name

  # Minimal bastion hardening: disable root login, keep SSH daemon only
  user_data = <<-EOF
    #!/bin/bash
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config
    systemctl restart sshd
  EOF

  metadata_options {
    http_tokens = "required" # Enforce IMDSv2
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name = "${var.project_name}-bastion-${var.environment}"
    Role = "bastion"
  }
}

# ─────────────────────────────────────────────
# Application Server (Private Subnet)
# Runs the SecureCart application behind the ALB
# ─────────────────────────────────────────────
resource "aws_instance" "app" {
  ami                         = var.app_ami
  instance_type               = var.app_instance_type
  subnet_id                   = var.private_subnet_1_id
  associate_public_ip_address = false
  vpc_security_group_ids      = [var.app_sg_id]
  key_name                    = aws_key_pair.app.key_name

  metadata_options {
    http_tokens = "required" # Enforce IMDSv2
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name = "${var.project_name}-app-${var.environment}"
    Role = "application"
  }
}
