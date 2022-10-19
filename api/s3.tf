
resource "aws_s3_bucket" "files" {
  bucket = "files-${var.name}"
  tags   = var.tags
  # force_destroy = true
}

resource "aws_s3_bucket_acl" "files_acl" {
  bucket = aws_s3_bucket.files.id
  acl    = "private"
}

resource "aws_s3_bucket" "assets" {
  bucket = "assets-${var.name}"
  tags   = var.tags
  # force_destroy = true
}

resource "aws_s3_bucket_acl" "assets_acl" {
  bucket = aws_s3_bucket.files.id
  acl    = "public-read"
}