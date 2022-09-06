resource "aws_lb_listener" "test_listener1" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.group1.arn
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "test_listner_rule_1" {
  listener_arn = aws_lb_listener.test_listener1.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group1.arn
  }

  condition {
    path_pattern {
      values = ["/test"]
    }
  }
}

resource "aws_lb_target_group" "group1" {
  name     = "group1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default_vpc.id
}

resource "aws_lb_target_group_attachment" "group1_att1" {
  target_group_arn = aws_lb_target_group.group1.arn
  target_id        = aws_instance.root1.id
  port             = 80
}