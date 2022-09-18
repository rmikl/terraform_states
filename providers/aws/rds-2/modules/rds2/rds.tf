data "aws_vpc" "default_vpc" {
  id = var.vpc_id
}

resource "aws_db_instance" "master" {
  allocated_storage    = 10
  engine               = "aurora-mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.traffic_mysql.id]
  availability_zone = "eu-central-1a"
  backup_retention_period = 5
  publicly_accessible    = true
  
  
  username             = var.db_username
  password             = var.db_password
}