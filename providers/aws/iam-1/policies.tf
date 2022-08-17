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
    user            = "${ element( aws_iam_user.loop_users.*.name,local.index_of_adam) }"
    policy_arn      = aws_iam_policy.policy1.arn
}

resource "aws_iam_group_policy_attachment" "policy2_attach" {
    group           = "${ element( aws_iam_group.loop_groups.*.name,local.index_of_group_staff) }"
    policy_arn      = aws_iam_policy.policy2.arn
}