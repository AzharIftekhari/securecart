#Application Load Balancer
resource "aws_lb" "securecart-alb" {
  name               = "securecart-alb"
  internal           = false # Internet-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
  ip_address_type    = "ipv4"

  tags = {
    Name = "securecart-alb"
  }
}

#HTTP Listener
resource "aws_lb_listener" "target-listener" {
  load_balancer_arn = aws_lb.securecart-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.securecart-tg.arn
  }
}

