## Create a VPC
#resource "aws_vpc" "eks_vpc" {
#  cidr_block = "10.0.0.0/16"
#  enable_dns_hostnames = true
#  enable_dns_support   = true
#  tags = {
#    Name = "eks-fargate-vpc"
#  }
#}
#
## Create public subnets
#resource "aws_subnet" "eks_public_subnet_a" {
#  vpc_id            = aws_vpc.eks_vpc.id
#  cidr_block        = "10.0.1.0/24"
#  availability_zone = "us-east-1a"
#  map_public_ip_on_launch = true
#  tags = {
#    Name = "eks-public-subnet-a"
#  }
#}
#
#resource "aws_subnet" "eks_public_subnet_b" {
#  vpc_id            = aws_vpc.eks_vpc.id
#  cidr_block        = "10.0.2.0/24"
#  availability_zone = "us-east-1b"
#  map_public_ip_on_launch = true
#  tags = {
#    Name = "eks-public-subnet-b"
#  }
#}
#
## Create private subnets for EKS
#resource "aws_subnet" "eks_private_subnet_a" {
#  vpc_id            = aws_vpc.eks_vpc.id
#  cidr_block        = "10.0.3.0/24"
#  availability_zone = "us-east-1a"
#  map_public_ip_on_launch = false
#  tags = {
#    Name = "eks-private-subnet-a"
#  }
#}
#
#resource "aws_subnet" "eks_private_subnet_b" {
#  vpc_id            = aws_vpc.eks_vpc.id
#  cidr_block        = "10.0.4.0/24"
#  availability_zone = "us-east-1b"
#  map_public_ip_on_launch = false
#  tags = {
#    Name = "eks-private-subnet-b"
#  }
#}
#
## Create an Internet Gateway
#resource "aws_internet_gateway" "eks_igw" {
#  vpc_id = aws_vpc.eks_vpc.id
#  tags = {
#    Name = "eks-igw"
#  }
#}
#
## Create a route table
#resource "aws_route_table" "eks_public_rt" {
#  vpc_id = aws_vpc.eks_vpc.id
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.eks_igw.id
#  }
#  tags = {
#    Name = "eks-public-rt"
#  }
#}
#
## Associate subnets with the route table
#resource "aws_route_table_association" "a" {
#  subnet_id      = aws_subnet.eks_public_subnet_a.id
#  route_table_id = aws_route_table.eks_public_rt.id
#}
#
#resource "aws_route_table_association" "b" {
#  subnet_id      = aws_subnet.eks_public_subnet_b.id
#  route_table_id = aws_route_table.eks_public_rt.id
#}