

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
