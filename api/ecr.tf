// api repository
resource "aws_ecr_repository" "api" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"
  tags                 = var.tags
}
