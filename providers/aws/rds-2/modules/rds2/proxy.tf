data "aws_vpc" "default_vpc" {
  id = "vpc-0efe235925cc8fce0"
}

data "aws_subnet_ids" "default_vpc_subnets_ids" {
  vpc_id = data.aws_vpc.default_vpc.id
}

resource "aws_db_proxy" "write_to_master" {
  name                   = "write_to_master"
  debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = false
  role_arn               = aws_iam_role.access_to_db_creds.arn
  vpc_security_group_ids = [aws_security_group.traffic_mysql.id]
  vpc_subnet_ids         = aws_subnet_ids.default_vpc_subnets_ids


  auth {
    auth_scheme = "SECRETS"
    description = "example"
    iam_auth    = "DISABLED"
    secret_arn  = aws_secretsmanager_secret.rds_creds.arn
  }
}

resource "aws_db_proxy_default_target_group" "def_rds" {
  db_proxy_name = aws_db_proxy.write_to_master.name
}

resource "aws_db_proxy_target" "master" {
  db_instance_identifier = aws_db_instance.master.id
  db_proxy_name          = aws_db_proxy.write_to_master.name
  target_group_name      = aws_db_proxy_default_target_group.def_rds.name
}

