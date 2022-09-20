terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

variable "aws_region" { 
  type = string
  default = "eu-central-1"
}

provider "aws" {
  region = var.aws_region
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

resource "aws_iam_role" "access_to_db_creds" {
  name = "iam_role_for_infra"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_secretsmanager_secret" "rds_creds" {
  name = "rds_creds6"
}


