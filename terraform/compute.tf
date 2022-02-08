# EC2 instance for bastion
resource "aws_instance" "bastion" {
    ami                    = var.ubuntu_ami
    instance_type          = var.ec2_instance_type
    key_name               = var.key_name
    subnet_id              = aws_subnet.public-subnet-a.id
    vpc_security_group_ids = [aws_security_group.bastion-public.id]

    tags = {
        Name = "bastion"
    }
}

# EC2 instance for running test services
resource "aws_instance" "holm-services" {
    ami                         = var.ubuntu_ami
    instance_type               = var.ec2_instance_type
    key_name                    = var.key_name
    subnet_id                   = aws_subnet.private-subnet.id
    vpc_security_group_ids      = [aws_security_group.holm-instance-sg.id, aws_security_group.monitoring.id]
    associate_public_ip_address = false
    root_block_device {
        volume_size = 10

        tags = {
            Name = "Root block device for holm-services-dev instance"
        }
    }

    tags = {
        Name = "holm-services"
    }
}

# Set up ansible inventory
data "template_file" "inventory" {
    template = "${file("./inventory.tpl")}"

    vars = {
        bastion_public_ip       = "${aws_instance.bastion.public_ip}"
        holmservices_private_ip = "${aws_instance.holm-services.private_ip}"
        key_path                = "${var.key_file_path}"
    }
}

resource "local_file" "create_inventory" {
    content  = "${data.template_file.inventory.rendered}"
    filename = "${var.ansible_hosts_file_location}"
}