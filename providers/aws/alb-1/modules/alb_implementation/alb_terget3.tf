
resource "aws_lb_listener_rule" "test_listener3" {
  listener_arn = aws_lb_listener.test_listener1.arn
  priority = 98

  action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "nothing here"
      status_code  = "404"
    }
  }
  condition {
    path_pattern {
      values = ["/admin"]
    }
  }
}
