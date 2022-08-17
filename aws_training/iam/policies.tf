resource "aws_iam_policy" "policy1"{
    name = "policy1"
    path = "/"
    description = "policy one should be asigned to adam user"
    policy = file("iam_policies/policy1.json")
}

resource "aws_iam_policy" "policy2"{
    name = "policy2"
    path = "/"
    description = "policy two should be assgined to staff group"
    policy = file("iam_policies/policy2.json")
}

resource "aws_iam_user_policy_attachment" "policy1_attach" {
    index_of_adam   = "${ index(var.user,"tera_adam") }"  
    user            = "${ element( aws_iam_user.loop_users.*.name,index_of_adam) }"
    policy_arn      = aws_iam_policy.policy1.arn
}

resource "aws_iam_group_policy_attachment" "policy2_attach" {
    index_of_staff  = "${ index(var.group,"tera_staff") }"
    group           = "${ element( aws_iam_group.loop_groups.*.name,index_of_staff) }"
    policy_arn      = aws_iam_policy.policy2.arn
}