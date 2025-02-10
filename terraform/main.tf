provider "aws" {
  region = "eu-north-1"
}

# VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Subnets
resource "aws_subnet" "eks_subnet_public" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Security Group
resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.eks_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# EKS Cluster
resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = aws_iam_role.eks_role.arn
  vpc_config {
    subnet_ids = [aws_subnet.eks_subnet_public.id]
  }
}

# IAM Role for Node Group
resource "aws_iam_role" "node_role" {
  name = "eks-node-role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Node Group (Worker Nodes)
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = [aws_subnet.eks_subnet_public.id]
  instance_types  = ["t3.medium"]
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}

# Load Balancer for Frontend
resource "aws_lb" "frontend_lb" {
  name               = "frontend-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.eks_sg.id]
  subnets           = [aws_subnet.eks_subnet_public.id]
}

# Persistent Storage for Prometheus/Grafana
resource "aws_ebs_volume" "prometheus_storage" {
  availability_zone = "eu-north-1a"
  size             = 10
  type             = "gp2"
}

output "eks_cluster_name" {
  value = aws_eks_cluster.my_cluster.name
}

output "eks_kubeconfig_command" {
  value = "aws eks update-kubeconfig --region eu-north-1 --name ${aws_eks_cluster.my_cluster.name}"
}
