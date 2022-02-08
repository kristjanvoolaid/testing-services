variable "region" {
    type        = string
    default     = "eu-central-1"
    description = "The region where to create infrastructure"
}

data "aws_availability_zones" "available" {
    state = "available"
}

variable "vpc_cidr" {
    default     = "10.5.0.0/20"
    description = "CIDR block that is used by VPC"
}

variable "subnet_cidr_newbits" {
    type        = string
    default     = 4
    description = "The newbits value as per cidrsubnet function docs"
}

variable "ubuntu_ami" {
    type        = string
    default     = "ami-0d527b8c289b4af7f"
    description = "UBUNTU LTS latest ami id"
}

variable "ec2_instance_type" {
    type        = string
    default     = "t2.micro"
    description = "EC2 instance type"
}

variable "key_name" {
    type        = string
    description = "The key name that will be used to SSH into EC2 instances"
}

variable "key_file_path" {
    type        = string
    description = "Location of the key-pair pem file"
}

variable "ip_address" {
  type        = string
  description = "IP address range that can connect to Bastion host"
}

variable "ansible_hosts_file_location" {
    type        = string
    default     = "~/hosts"
    description = "Ansible hosts file location for the local instance"
}