

resource "aws_iam_group" "loop_groups"{
    count = length(var.groups)
    path = "/"
    name = var.groups[count.index]
}

resource "aws_iam_group_membership" "tera_admin" {
    name = "tera_admin_members"
    users = [
        "${ element(aws_iam_user.loop_users.*.name,local.index_of_tom)}",
        "${ element(aws_iam_user.loop_users.*.name,local.index_of_greg)}"
    ]
    
    group = "${ element(aws_iam_group.loop_groups.*.name,local.index_of_group_admin) }"
}

resource "aws_iam_group_membership" "tera_staff" {
    name = "tera_staff_members"

    users = [
        "${ element(aws_iam_user.loop_users.*.name,local.index_of_sally)}",
        "${ element(aws_iam_user.loop_users.*.name,local.index_of_geralt)}",
        "${ element(aws_iam_user.loop_users.*.name,local.index_of_alice)}"
    ]
    group = "${element(aws_iam_group.loop_groups.*.name,local.index_of_group_staff)}"
}

resource "aws_iam_group_membership" "tera_audit" {
    name = "tera_audit_members"
    users = [
        "${ element(aws_iam_user.loop_users.*.name,local.index_of_tom)}",
        "${ element(aws_iam_user.loop_users.*.name,local.index_of_sally)}"
    ]

    group = "${element(aws_iam_group.loop_groups.*.name,local.index_of_group_audit)}"
}
