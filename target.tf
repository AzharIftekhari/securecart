#Target Group
resource "aws_lb_target_group" "securecart-tg" {
  name        = "securecart-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.securecart-vpc.id

  health_check {
    path                = "/"
  }
}

#Attach EC2 to Target Group
resource "aws_lb_target_group_attachment" "target-attach" {
  target_group_arn = aws_lb_target_group.securecart-tg.arn
  target_id        = aws_instance.securecart-app.id
  port             = 80
}