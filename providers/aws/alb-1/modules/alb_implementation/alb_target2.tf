resource "aws_lb_listener_rule" "test_listner_rule_2" {
  listener_arn = aws_lb_listener.test_listener1.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group2.arn
  }

  condition {
    path_pattern {
      values = ["/index.html"]
    }
  }
}

resource "aws_lb_target_group" "group2" {
  name     = "group2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default_vpc.id
}

resource "aws_lb_target_group_attachment" "group2_att1" {
  target_group_arn = aws_lb_target_group.group2.arn
  target_id        = aws_instance.root2.id
  port             = 80
}