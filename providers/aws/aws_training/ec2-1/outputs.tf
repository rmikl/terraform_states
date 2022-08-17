output "instance_ip" {
    description = "Public ip of an generated example instance"
    value = aws_instance.example-instance.public_ip
}

output "instance_dns" {
    description = "DNS of an generated example instance"
    value = aws_instance.example-instance.public_dns
}