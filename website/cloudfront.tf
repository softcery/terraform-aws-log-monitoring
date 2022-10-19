
// website bucket iam policy
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website.json
}

// website bucket iam policy document that allows access only from cloudfront distribution
// this is needed to prevent bypassing cloudfront and accessing s3 directly
data "aws_iam_policy_document" "website" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.website.iam_arn]
    }
  }
}

// identity that represents cloudfront distribution
resource "aws_cloudfront_origin_access_identity" "website" {
  comment = "website-${var.postfix}"
}

// cloudfront distribution, basically a cdn for the website bucket
resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.website.bucket

    // https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.website.cloudfront_access_identity_path
    }
  }

  // alias is needed to allow access by custom domain (see route53 record below)
  aliases = [var.domain]

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "website-${var.postfix}"
  default_root_object = "index.html"
  tags                = var.tags

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.website.bucket

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    compress               = true
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # caching images
  ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_s3_bucket.website.bucket

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 604800  // 7 days
    max_ttl                = 2419000 // 28 days
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # caching fonts
  ordered_cache_behavior {
    path_pattern     = "/fonts/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_s3_bucket.website.bucket

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 604800  // 7 days
    max_ttl                = 2419000 // 28 days
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  // https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/PriceClass.html
  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }

    # geo_restriction {
    #   restriction_type = "whitelist"
    #   locations        = ["US", "CA", "GB", "DE"]
    # }
  }

  viewer_certificate {
    # cloudfront_default_certificate = true
    acm_certificate_arn = aws_acm_certificate.website.arn
    ssl_support_method  = "sni-only"
  }

  // redirect to index.html on 404 error cuz we use single page app
  custom_error_response {
    error_code         = "404"
    response_code      = 200
    response_page_path = "/index.html"
  }
}
