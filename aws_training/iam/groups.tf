resource "aws_iam_group" "loop_groups"{
    count = length(var.groups)
    path = "/"
    name = var.groups[count.index]
    tags = {
        terraform = "true"
    }
}

resource "aws_iam_group_membership" "tera_admin" {
    name = "tera_admin_members"
    index_of_tom = "${ index(var.users,"tera_tom") }"
    index_of_greg = "${ index(var.users,"tera_greg") }"
    users = [
        "${ element(var.loop_users.*.name,index_of_tom)}",
        "${element(var.loop_users.*.name,index_of_greg)}"
    ]
    
    index_of_group_admin = "${index(var.loop_groups,"tera_admin")}"
    group = "${ element(var.loop_groups.*.name,index_of_group_admin) }"
}

resource "aws_iam_group_membership" "tera_staff" {
    name = "tera_staff_members"

    index_of_sally = "${ index(var.users,"tera_sally") }"
    index_of_geralt = "${ index(var.users,"tera_geralt") }"
    index_of_alice = "${ index(var.users,"tera_alice") }"

    users = [
        "${ element(var.loop_users.*.name,index_of_sally)}",
        "${ element(var.loop_users.*.name,index_of_geralt)}",
        "${ element(var.loop_users.*.name,index_of_alice)}"
    ]

    index_of_group_staff = "${index(var.loop_groups,"tera_staff")}"
    group = "${element(var.loop_groups.*.name,index_of_group_staff)}"
}

resource "aws_iam_group_membership" "tera_audit" {
    name = "tera_audit_members"
    index_of_sally = "${ index(var.users,"tera_sally") }"
    index_of_tom = "${ index(var.users,"tera_tom") }"
    users = [
        "${ element(var.loop_users.*.name,index_of_tom)}",
        "${ element(var.loop_users.*.name,index_of_sally)}"
    ]

    index_of_group_audit = "${index(var.loop_groups,"tera_staff")}"
    group = "${element(var.loop_groups.*.name,index_of_group_staff)}"
}
