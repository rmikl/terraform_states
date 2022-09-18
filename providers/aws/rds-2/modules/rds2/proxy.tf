resource "aws_db_proxy" "example" {
  name                   = "example"
  debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = true
  role_arn               = aws_iam_role.example.arn
  vpc_security_group_ids = [aws_security_group.example.id]
  vpc_subnet_ids         = [aws_subnet.example.id]
}