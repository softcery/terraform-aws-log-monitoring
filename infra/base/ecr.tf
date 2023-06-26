resource "aws_ecr_repository" "base" {
  name = var.name

  image_tag_mutability = "MUTABLE"

  tags = local.tags
}
