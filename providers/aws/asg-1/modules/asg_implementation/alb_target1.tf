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
      values = ["/"]
    }
  }
}

resource "aws_lb_target_group" "group1" {
  name     = "group1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default_vpc.id
  health_check {
    interval            = 30
    path                = "/index.html"
    port                = 80
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTP"
    matcher             = "200,202"
  }

}
