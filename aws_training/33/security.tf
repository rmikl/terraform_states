resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4XYXOoP6UfkbqYWKRcP1KKZUgnni63PBNceJ8k8d6BdnUgfEKMWQEHxh7p2tXJfrsMfU23LeXX5VCiCaqf6jcClew6JYy8Rq+cUENqKFB1CrkcgVT/whv/gX41XiZvNl4T80AnzAvp4MG/2w396v05kMyWoAq+NjIDGRPUvXnbovG5T5oDXHDZ0vV++cHvFJ6kG6woR8lNhj81LWshJoOhM+lJNzBms3sAQ6BXdMxEkjodzKCq03Is9wPffgM8zin22UFtcK5hz51zYU41CPmltwrLH0IGWR7gVdCV8V2m9Z4opyha/TJQpA2XwZSzRrx9pdcTkeZS4z6g+W+J7gQZixm9E2CqVXAq+FsS1yHLx912fz5PkrcTI9jSBEZ+p64roABMQsLLdcpPpFzE+613MaToZTXCp2Hj/z++rmwMf+dqtsSX51EFwjJdwOb+athSRMNc781/lTWepLnvpPiqlGlQl49knrLrBciFeSpQhPbPSa4oXnP/zEFh+1turk= robert@DESKTOP-LA8RN3P"
  tags = {
    name = "ssh_key"
  }
}

resource "aws_key_pair" "ssh_key_linux" {
  key_name   = "ssh_key_linux"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6Za6287De2wuLhhy1flwqx52in9ulkHAt20PdiLUrGZJB4sTYd2QLfT7lkCQ7wT7M0TUV1NGZAHLUwO1NGMYj2Abdt6QlZTQZj2nj1ZCKDuKZduc6kMWDs/Dmani0kXnc2E8qKZ2JlV2E4xgLVYwAfd67DOCKpc2omnnj13I27DTwbmm482CoDOlafZL7f2Xmi0/29KokgSbxJ5qn6pitn7jY3BlHd2dr2lHZUE31zuNxgqEJNMU/ZzaTK2CfHYSnbVY1rB/t1EmKnNw9H7+Jl6s6yDsO9E4jQTA1snmrhG0bsqopArXj/7aL3Gs9rUXYEfSxF4Y455wUJlGg3+YJqENb9QiEEXG+ikw8KmRHafhS8blMSDEALiJY9fYb9dWEBHzlWRbMims+o4DNYla6zsGnlULqXexNEjUF2mFFurQ/x9IPQ1tGde+DnstQUAr2ZtjoDRnJjo5S5sGlcabc6tXHKS7fgxt0vr/K0nGH2etzqXAJu2QSOLJymWR2GuU= robert@robert-MacBookAir"
  tags = {
    name = "ssh_key_linux"
  }
}


resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}