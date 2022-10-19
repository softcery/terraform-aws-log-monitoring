resource "aws_s3_bucket" "website" {
  bucket = "website-${var.postfix}"
  tags   = var.tags
  # force_destroy = true
}

resource "aws_s3_bucket_acl" "files_acl" {
  bucket = aws_s3_bucket.website.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

  /*  
  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
  */
}


resource "aws_s3_bucket_cors_configuration" "website_cors_config" {
  bucket = aws_s3_bucket.website.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
