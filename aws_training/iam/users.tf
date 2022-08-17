resource "aws_iam_user" "loop_users"{
    count = length(var.users)
    path = "/"
    tags = {
        non-root = "true"
        terraform = "true"
    }
    name = var.users(count.index)
}


