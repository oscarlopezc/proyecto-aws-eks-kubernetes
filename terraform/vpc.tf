resource "aws_vpc" "eks_vpc" {

  cidr_block           = local.vpc_cidr

  enable_dns_support   = true

  enable_dns_hostnames = true

  tags = {
    Name = "${local.project_name}-vpc"
  }

}


resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${local.project_name}-igw"
  }

}

resource "aws_subnet" "public_subnet_1" {

  vpc_id                  = aws_vpc.eks_vpc.id

  cidr_block              = local.public_subnets[0]

  availability_zone       = local.availability_zones[0]

  map_public_ip_on_launch = true

  tags = {

    Name = "${local.project_name}-public-subnet-1"

    "kubernetes.io/role/elb" = "1"

  }

}

resource "aws_subnet" "public_subnet_2" {

  vpc_id                  = aws_vpc.eks_vpc.id

  cidr_block              = local.public_subnets[1]

  availability_zone       = local.availability_zones[1]

  map_public_ip_on_launch = true

  tags = {

    Name = "${local.project_name}-public-subnet-2"

    "kubernetes.io/role/elb" = "1"

  }

}


resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.project_name}-public-rt"
  }

}

resource "aws_route_table_association" "public_subnet_1_assoc" {

  subnet_id = aws_subnet.public_subnet_1.id

  route_table_id = aws_route_table.public_rt.id

}


resource "aws_route_table_association" "public_subnet_2_assoc" {

  subnet_id = aws_subnet.public_subnet_2.id

  route_table_id = aws_route_table.public_rt.id

}
resource "aws_security_group" "eks_cluster_sg" {

  name        = "${local.project_name}-cluster-sg"

  description = "Security Group for EKS Cluster"

  vpc_id = aws_vpc.eks_vpc.id

  ingress {

    from_port = 443

    to_port = 443

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }

  tags = {

    Name = "${local.project_name}-cluster-sg"

  }

}

resource "aws_subnet" "private_subnet_1" {

  vpc_id = aws_vpc.eks_vpc.id

  cidr_block = local.private_subnets[0]

  availability_zone = local.availability_zones[0]

  tags = {
    Name = "${local.project_name}-private-subnet-1"

    "kubernetes.io/role/internal-elb" = "1"
  }

}

resource "aws_subnet" "private_subnet_2" {

  vpc_id = aws_vpc.eks_vpc.id

  cidr_block = local.private_subnets[1]

  availability_zone = local.availability_zones[1]

  tags = {
    Name = "${local.project_name}-private-subnet-2"

    "kubernetes.io/role/internal-elb" = "1"
  }

}

resource "aws_eip" "nat_eip" {

  domain = "vpc"

  tags = {
    Name = "${local.project_name}-nat-eip"
  }

}

resource "aws_nat_gateway" "nat_gateway" {

  allocation_id = aws_eip.nat_eip.id

  subnet_id = aws_subnet.public_subnet_1.id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Name = "${local.project_name}-nat-gateway"
  }

}

resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.eks_vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat_gateway.id

  }

  tags = {
    Name = "${local.project_name}-private-rt"
  }

}

resource "aws_route_table_association" "private_subnet_1_assoc" {

  subnet_id = aws_subnet.private_subnet_1.id

  route_table_id = aws_route_table.private_rt.id

}

resource "aws_route_table_association" "private_subnet_2_assoc" {

  subnet_id = aws_subnet.private_subnet_2.id

  route_table_id = aws_route_table.private_rt.id

}