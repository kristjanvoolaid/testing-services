# Public security group
resource "aws_security_group" "bastion-public" {
    name        = "Public SG"
    description = "Public security group for bastion host"
    vpc_id      = aws_vpc.DEV.id

    ingress {
        description = "Allow SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${var.ip_address}/32"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Bastion-public"
    }
}

# Security group for testing instance
resource "aws_security_group" "holm-instance-sg" {
    name        = "Holm testing instance SG"
    description = "Security group for testing instance"
    vpc_id      = aws_vpc.DEV.id

    ingress {
        description = "Allow SSH from bastion host"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${aws_instance.bastion.private_ip}/32"]
    }

    ingress {
        description = "fancypage"
        from_port   = 4345
        to_port     = 4345
        protocol    = "tcp"
        cidr_blocks = [aws_vpc.DEV.cidr_block]
    }

    ingress {
        description = "notsofancypage"
        from_port   = 4346
        to_port     = 4346
        protocol    = "tcp"
        cidr_blocks = [aws_vpc.DEV.cidr_block]
    }

    ingress {
        description = "Monitoring"
        from_port   = 9100
        to_port     = 9100
        protocol    = "tcp"
        cidr_blocks = [aws_vpc.DEV.cidr_block]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Holm instance SG"
    }
}

# Security group for ALB
resource "aws_security_group" "alb-sg" {
    name        = "ALB SG"
    description = "Security group for ALB"
    vpc_id      = aws_vpc.DEV.id

    ingress {
        description = "Allow access to fancypage"
        from_port   = 4345
        to_port     = 4345
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow access to notsofancypage"
        from_port   = 4346
        to_port     = 4346
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ALB-SG"
    }
}

# Security group for holm-instance monitoring
resource "aws_security_group" "monitoring" {
    name        = "Monitoring SG"
    description = "Security group for Holm instance monitoring"
    vpc_id      = aws_vpc.DEV.id

    ingress {
        description = "Allow access to fancypage monotoring"
        from_port   = 9100
        to_port     = 9100
        protocol    = "tcp"
        cidr_blocks = [aws_vpc.DEV.cidr_block]
    }

    tags = {
        Name = "Monitoring SG"
    }
}