provider "aws" {
  region = "eu-west-2"
}

# VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Internet Gateway
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id
}

# Route Table
resource "aws_route_table" "eks_rt" {
  vpc_id = aws_vpc.eks_vpc.id
}

# Route to Internet
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.eks_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eks_igw.id
}

# Public Subnets with Required Tags
resource "aws_subnet" "eks_subnet_public_a" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"
  tags = {
    "kubernetes.io/cluster/my-cluster" = "shared"
    "kubernetes.io/role/elb"           = "1"
    "kubernetes.io/role/internal-elb"  = "1"
  }
}

resource "aws_subnet" "eks_subnet_public_b" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"
  tags = {
    "kubernetes.io/cluster/my-cluster" = "shared"
    "kubernetes.io/role/elb"           = "1"
    "kubernetes.io/role/internal-elb"  = "1"
  }
}

# Associate Subnets with Route Table
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.eks_subnet_public_a.id
  route_table_id = aws_route_table.eks_rt.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.eks_subnet_public_b.id
  route_table_id = aws_route_table.eks_rt.id
}

# Security Groups
resource "aws_security_group" "eks_sg" {
  name   = "eks-security-group"
  vpc_id = aws_vpc.eks_vpc.id

  ingress {
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach AWS-Managed Policies to EKS Cluster Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_role.name
}

# IAM Role for Node Group
resource "aws_iam_role" "node_role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach AWS-Managed Policies to Node Role
resource "aws_iam_role_policy_attachment" "eks_node_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_role.name
  
  depends_on = [aws_iam_role.node_role]
}

resource "aws_iam_role_policy_attachment" "cni_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.node_role.name
}
resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.node_role.name
}

# EKS Cluster
resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = aws_iam_role.eks_role.arn
  version  = 1.32

  vpc_config {
    subnet_ids = [aws_subnet.eks_subnet_public_a.id, aws_subnet.eks_subnet_public_b.id]
  }
  
  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

# Node Group
resource "aws_eks_node_group" "node_group" {
  cluster_name  = aws_eks_cluster.my_cluster.name
  node_role_arn = aws_iam_role.node_role.arn
  subnet_ids    = [aws_subnet.eks_subnet_public_a.id, aws_subnet.eks_subnet_public_b.id]

  instance_types = ["t3.medium"]
  ami_type       = "AL2_x86_64"

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  
  depends_on = [aws_iam_role_policy_attachment.eks_node_policy_attach,
                aws_iam_role_policy_attachment.cni_policy_attach,
                aws_iam_role_policy_attachment.ssm_policy_attach,
                aws_iam_role_policy_attachment.cloudwatch_policy_attach]
}

# addon for managing eks cluster
resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.my_cluster.name
  addon_name    = "vpc-cni"
  addon_version = "v1.19.2-eksbuild.1"
}

# Outputs
output "eks_cluster_name" {
  value = aws_eks_cluster.my_cluster.name
}

output "eks_kubeconfig_command" {
  value = "aws eks update-kubeconfig --region eu-west-2 --name ${aws_eks_cluster.my_cluster.name}"
}


