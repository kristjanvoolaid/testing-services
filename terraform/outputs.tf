# Bastion public ID
output "bastion-public-address" {
    value       = aws_instance.bastion.public_ip
    description = "Public IP address of bastion host"
}

# Holm instance private IP
output "holm-instance-ip" {
    value       = aws_instance.holm-services.private_ip
    description = "Private IP address of holm-services instance"
}

# Holm instance security group ID
output "holm-instance-sg" {
    value       = aws_security_group.holm-instance-sg.id
    description = "Holm instance security-group ID"
}