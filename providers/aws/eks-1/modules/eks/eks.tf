data "aws_vpc" "default_vpc" {
  id = "vpc-0efe235925cc8fce0"
}

data "aws_subnet_ids" "default_vpc_subnets" {
  vpc_id = data.aws_vpc.default_vpc.id
}


resource "aws_eks_cluster" "sample_cluster" {
  name     = "example"
  role_arn = aws_iam_role.k8s.arn

  vpc_config {
    subnet_ids = data.aws_subnet_ids.default_vpc_subnets.ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.k8s
  ]
}

