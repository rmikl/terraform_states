//resource "aws_db_instance" "master" {
//  allocated_storage    = 10
//  engine               = "aurora-mysql"
//  engine_version       = "8.0.28"
//  instance_class       = "db.t3.micro"
//  name                 = "mydb"
//  parameter_group_name = "default.mysql5.7"
//  skip_final_snapshot  = true
//  vpc_security_group_ids = [aws_security_group.traffic_mysql.id]
//  availability_zone = "eu-central-1a"
//  backup_retention_period = 5
//  publicly_accessible    = true
//  
//  
//  username             = var.db_username
//  password             = var.db_password
//}

resource "aws_rds_cluster_instance" "master" {
  count              = 1
  identifier         = "aurora-rds-${count.index}"
  cluster_identifier = aws_rds_cluster.master.id
  instance_class     = "db.t3.micro"
  engine             = "aurora-mysql"
  engine_version     = "5.7"
  publicly_accessible =  true
}

resource "aws_rds_cluster" "master" {
  cluster_identifier = "aurora-rds"
  availability_zones = [var.zone1,  var.zone2, var.zone3 ]
  database_name      = "mydb"
  master_username    = var.db_username
  master_password    = var.db_password
  engine = "aurora-mysql"
  skip_final_snapshot  = true

}