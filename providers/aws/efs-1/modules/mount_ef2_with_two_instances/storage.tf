# Creating Amazon EFS File system
resource "aws_efs_file_system" "myfilesystem" {
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}

resource "aws_efs_access_point" "test" {
  file_system_id = aws_efs_file_system.myfilesystem.id
}
resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.myfilesystem.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "Policy01",
    "Statement": [
        {
            "Sid": "Statement",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Resource": "${aws_efs_file_system.myfilesystem.arn}",
            "Action": [
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientRootAccess",
                "elasticfilesystem:ClientWrite"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_efs_mount_target" "alpha" {
  file_system_id = aws_efs_file_system.myfilesystem.id
  subnet_id      = data.aws_subnet.host_subnet.id
  security_groups = [ aws_security_group.traffic_to_efs.id ] 
}