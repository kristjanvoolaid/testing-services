# VPC creation
resource "aws_vpc" "DEV" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true

    tags = {
        Name = "DEV-VPC"
    }
}

# Internet gateway for DEV VPC
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.DEV.id

    tags = {
        Name = "DEV VPC IGW"
    }
}

# Public subnet a
resource "aws_subnet" "public-subnet-a" {
    vpc_id                  = aws_vpc.DEV.id
    cidr_block              = cidrsubnet(var.vpc_cidr, var.subnet_cidr_newbits, 0)
    availability_zone       = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true

    tags = {
        Name = "Public subnet a"
    }
}

# Public subnet b
resource "aws_subnet" "public-subnet-b" {
    vpc_id                  = aws_vpc.DEV.id
    cidr_block              = cidrsubnet(var.vpc_cidr, var.subnet_cidr_newbits, 1)
    availability_zone       = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = true

    tags = {
        Name = "Public subnet b"
    }
}

# Subnet for test instance
resource "aws_subnet" "private-subnet" {
    vpc_id                  = aws_vpc.DEV.id
    cidr_block              = cidrsubnet(var.vpc_cidr, var.subnet_cidr_newbits, 2)
    availability_zone       = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = false

    tags = {
        Name = "Private subnet"
    }
}

# Elastic IP for NAT
resource "aws_eip" "nat-a" {
    vpc = true
}

# Elastic IP for NAT
resource "aws_eip" "nat-b" {
    vpc = true
}

resource "aws_nat_gateway" "nat_gw_a" {
    allocation_id = aws_eip.nat-a.id
    subnet_id     = aws_subnet.public-subnet-a.id
    depends_on    = [aws_internet_gateway.main]

    tags = {
        Name = "NAT GW"
    }
}

resource "aws_nat_gateway" "nat_gw_b" {
    allocation_id = aws_eip.nat-b.id
    subnet_id     = aws_subnet.public-subnet-b.id
    depends_on    = [aws_internet_gateway.main]

    tags = {
        Name = "NAT GW"
    }
}

# Public route
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.DEV.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "PUBLIC RT"
    }
}

# Private route
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.DEV.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gw_a.id
    }

    tags = {
        Name = "PRIVATE RT"
    }
}

# Route tables association
resource "aws_route_table_association" "public-a" {
    subnet_id      = aws_subnet.public-subnet-a.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-b" {
    subnet_id      = aws_subnet.public-subnet-b.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    subnet_id      = aws_subnet.private-subnet.id
    route_table_id = aws_route_table.private.id
}