resource "aws_ecr_repository" "backend" {

  name = "${local.project_name}-backend"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${local.project_name}-backend"
  }

}

resource "aws_ecr_repository" "frontend" {

  name = "${local.project_name}-frontend"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${local.project_name}-frontend"
  }

}

output "backend_ecr_url" {

  description = "Backend ECR Repository URL"

  value = aws_ecr_repository.backend.repository_url

}

output "frontend_ecr_url" {

  description = "Frontend ECR Repository URL"

  value = aws_ecr_repository.frontend.repository_url

}