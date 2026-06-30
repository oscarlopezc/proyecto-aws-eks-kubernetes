variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "kubernetes_version" {
  description = "EKS Kubernetes Version"
  type        = string
  default     = "1.36"
}