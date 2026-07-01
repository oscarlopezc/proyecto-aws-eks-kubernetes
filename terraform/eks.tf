resource "aws_eks_cluster" "main" {

  name = "${local.project_name}-cluster"

  role_arn = aws_iam_role.eks_cluster_role.arn

  version = var.kubernetes_version

  vpc_config {

    subnet_ids = [

      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id,
      aws_subnet.private_subnet_1.id,
      aws_subnet.private_subnet_2.id

    ]

    security_group_ids = [

      aws_security_group.eks_cluster_sg.id

    ]

    endpoint_private_access = false

    endpoint_public_access = true

  }

  depends_on = [

    aws_iam_role_policy_attachment.eks_cluster_policy

  ]

  tags = {

    Name = "${local.project_name}-cluster"

  }

}

resource "aws_eks_node_group" "main" {

  cluster_name = aws_eks_cluster.main.name

  node_group_name = "${local.project_name}-workers"

  node_role_arn = aws_iam_role.eks_node_role.arn

  subnet_ids = [

    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id

  ]

  scaling_config {

    desired_size = 1

    min_size = 1

    max_size = 2

  }

  instance_types = [

    "t3.medium"

  ]

  capacity_type = "ON_DEMAND"

  depends_on = [

    aws_iam_role_policy_attachment.worker_node_policy,

    aws_iam_role_policy_attachment.ecr_policy,

    aws_iam_role_policy_attachment.cni_policy

  ]

  tags = {

    Name = "${local.project_name}-workers"

  }

}