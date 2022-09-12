data "aws_vpc" "default_vpc" {
  id = var.vpc_id
}

resource "aws_db_instance" "master" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.trafic_in.id]
  availability_zone = "eu-central-1a"
  backup_retention_period = 5


}

resource "aws_db_instance" "rreplica" {
  identifier             = "rreplica"
  replicate_source_db    = aws_db_instance.master.id
  name                   = "rreplica"
  instance_class         = "db.t2.micro"
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  vpc_security_group_ids = [aws_security_group.trafic_in.id]
  username               = var.db_username
  password               = var.db_password
  availability_zone      = "eu-central-1b"

}

resource "aws_security_group" "trafic_in" {
  vpc_id      = "${data.aws_vpc.default_vpc.id}"
  name        = "trafic_in"
  description = "Allow all inbound for Postgres"
ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
