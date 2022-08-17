variable "aws_region"{
    type = string
    default = "eu-central-1"
}

variable "users" {
    type = list(string)
    default = ["tera_tom","tera_greg","tera_sally","tera_geralt","tera_alice","tera_adam"]
}

variable "groups" { 
    type = list(string)
    default = ["tera_admin","tera_staff","tera_audit"]
}

locals{
    index_of_tom = "${ index(var.users,"tera_tom") }"
    index_of_greg = "${ index(var.users,"tera_greg") }"
    index_of_sally = "${ index(var.users,"tera_sally") }"
    index_of_geralt = "${ index(var.users,"tera_geralt") }"
    index_of_alice = "${ index(var.users,"tera_alice") }"
    index_of_adam = "${ index(var.users,"tera_adam") }"
    
    index_of_group_admin = "${index(var.groups,"tera_admin")}"
    index_of_group_staff = "${index(var.groups,"tera_staff")}"
    index_of_group_audit = "${index(var.groups,"tera_audit")}"
}
