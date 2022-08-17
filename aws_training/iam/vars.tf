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