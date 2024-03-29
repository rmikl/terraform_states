resource "aws_security_group" "traffic_ec2" {
  name        = "traffic_to_infra"
  description = "allow neede traffic for ec2"

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

    egress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "traffic_mysql" {
  vpc_id      = "${data.aws_vpc.default_vpc.id}"
  name        = "traffic_mysql"
  description = "Allow all inbound for mysql"
ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

data "aws_secretsmanager_secret" "rds_creds" {
  name = "rds_creds6"
}

resource "aws_secretsmanager_secret_version" "rds_creds" {
  secret_id     = data.aws_secretsmanager_secret.rds_creds.id
  secret_string = jsonencode({"password": "${var.db_password}","username":"${var.db_username}"})
}

resource "aws_iam_role" "access_to_db_creds" {
  name = "iam_role_for_infra"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "access_to_creds" {
  name = "access_to_db_creds"
  role = aws_iam_role.access_to_db_creds.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetRandomPassword",
                "secretsmanager:CreateSecret",
                "secretsmanager:ListSecrets"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": [
                     "${data.aws_secretsmanager_secret.rds_creds.arn}"
            ]
        }
    ]
}
EOF
}