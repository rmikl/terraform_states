resource "aws_security_group" "traffic_lb" {
  name        = "traffic_lb"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "traffic_to_ec2" {
  name        = "traffic_to_infra"
  description = "Allow ssh inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_elb" "classic_lb" {
  name               = "classic-lb"
  availability_zones = [ var.zone1 ]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 5
  }

  instances                   = [aws_instance.root1.id, aws_instance.root2.id ]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  //source_security_group_id = aws_security_group.lb_sg.id
}

data "aws_vpc" "default_vpc" {
  id = "vpc-0efe235925cc8fce0"
}

data "aws_subnet_ids" "default_vpc_subnets_ids" {
  vpc_id = data.aws_vpc.default_vpc.id
}

resource "aws_lb" "app_lb" {
  name               = "app-lb"
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default_vpc_subnets_ids.ids
  enable_cross_zone_load_balancing = true
  security_groups = [aws_security_group.traffic_lb.id]
}
