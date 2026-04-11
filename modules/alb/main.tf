# ═══════════════════════════════════════════════════════════
#  Module: alb
#  Resources: Application Load Balancer, Target Group,
#             HTTP Listener, Target Group Attachment
# ═══════════════════════════════════════════════════════════

# ─────────────────────────────────────────────
# Application Load Balancer
# Internet-facing, placed in both public subnets for HA
# ─────────────────────────────────────────────
resource "aws_lb" "secure-alb" {
  name               = "${var.project_name}-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]
  ip_address_type    = "ipv4"

  # Enable access logs to S3 in production (bucket must have the LB policy)
  # access_logs {
  #   bucket  = "your-access-log-bucket"
  #   prefix  = "alb"
  #   enabled = true
  # }

  tags = {
    Name = "${var.project_name}-alb-${var.environment}"
  }
}

# ─────────────────────────────────────────────
# Target Group
# Receives traffic forwarded from the ALB listener
# ─────────────────────────────────────────────
resource "aws_lb_target_group" "secure-tg" {
  name        = "${var.project_name}-tg-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.project_name}-tg-${var.environment}"
  }
}

# ─────────────────────────────────────────────
# HTTP Listener (port 80)
# Forwards traffic to the target group.
# For production: redirect HTTP → HTTPS here and add an HTTPS listener.
# ─────────────────────────────────────────────
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.secure-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.secure-tg.arn
  }

  # For production with HTTPS, use this instead:
  # default_action {
  #   type = "redirect"
  #   redirect {
  #     port        = "443"
  #     protocol    = "HTTPS"
  #     status_code = "HTTP_301"
  #   }
  # }
}

# ─────────────────────────────────────────────
# Target Group Attachment
# Registers the app EC2 instance with the target group
# ─────────────────────────────────────────────
resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = aws_lb_target_group.secure-tg.arn
  target_id        = var.app_instance_id
  port             = 80
}
