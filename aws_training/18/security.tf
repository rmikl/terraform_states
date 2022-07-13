resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4XYXOoP6UfkbqYWKRcP1KKZUgnni63PBNceJ8k8d6BdnUgfEKMWQEHxh7p2tXJfrsMfU23LeXX5VCiCaqf6jcClew6JYy8Rq+cUENqKFB1CrkcgVT/whv/gX41XiZvNl4T80AnzAvp4MG/2w396v05kMyWoAq+NjIDGRPUvXnbovG5T5oDXHDZ0vV++cHvFJ6kG6woR8lNhj81LWshJoOhM+lJNzBms3sAQ6BXdMxEkjodzKCq03Is9wPffgM8zin22UFtcK5hz51zYU41CPmltwrLH0IGWR7gVdCV8V2m9Z4opyha/TJQpA2XwZSzRrx9pdcTkeZS4z6g+W+J7gQZixm9E2CqVXAq+FsS1yHLx912fz5PkrcTI9jSBEZ+p64roABMQsLLdcpPpFzE+613MaToZTXCp2Hj/z++rmwMf+dqtsSX51EFwjJdwOb+athSRMNc781/lTWepLnvpPiqlGlQl49knrLrBciFeSpQhPbPSa4oXnP/zEFh+1turk= robert@DESKTOP-LA8RN3P"
  tags = {
    name = "ssh_key"
  }

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_instance.example-instance.id

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_instance.example-instance.cidr_block]
    ipv6_cidr_blocks = [aws_instance.example-instance..ipv6_cidr_block]
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