output "jump_host_ip" {
    description = "ip of jump host"
    value = aws_instance.jump_host.public_ip
}