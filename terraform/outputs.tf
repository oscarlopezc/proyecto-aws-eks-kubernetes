output "cluster_name" {

  description = "EKS Cluster Name"

  value = aws_eks_cluster.main.name

}

output "cluster_endpoint" {

  description = "EKS Cluster Endpoint"

  value = aws_eks_cluster.main.endpoint

}

output "cluster_version" {

  description = "Kubernetes Version"

  value = aws_eks_cluster.main.version

}

output "cluster_arn" {

  description = "Cluster ARN"

  value = aws_eks_cluster.main.arn

}

output "vpc_id" {

  description = "VPC ID"

  value = aws_vpc.eks_vpc.id

}

output "public_subnets" {

  description = "Public Subnets"

  value = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

}

output "private_subnets" {

  description = "Private Subnets"

  value = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

}