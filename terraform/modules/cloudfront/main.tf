data "aws_route53_zone" "my_domain" {
  name = var.host_domain_name
}


#################################
# domain
#################################
# Provider for ACM CloudFront
provider "aws" {
  alias  = "acm_provider"
  region = "us-east-1"
}

# ACM Certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  provider          = aws.acm_provider

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = data.aws_route53_zone.my_domain.id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
  provider                = aws.acm_provider
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.my_domain.id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = replace(aws_cloudfront_distribution.distribution.domain_name, "/[.]$/", "")
    zone_id                = aws_cloudfront_distribution.distribution.hosted_zone_id
    evaluate_target_health = true
  }

  depends_on = [aws_cloudfront_distribution.distribution]
}

#################################
# CloudFront
#################################

data "aws_cloudfront_origin_request_policy" "managed_viewer_policy" {
  name = "Managed-AllViewerExceptHostHeader"
}


resource "aws_cloudfront_distribution" "distribution" {
  enabled = true
  # CNAMEの追加
  aliases = [var.domain_name]

  origin {
    domain_name = var.api_gateway_domain_name
    origin_id   = var.api_gateway_domain_name

    # ビューワープロトコルポリシー
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }


  # Chach policy :https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html#managed-cache-policy-caching-disabled
  default_cache_behavior {
    # 許可された HTTP メソッド
    allowed_methods          = ["GET", "HEAD", "OPTIONS"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    target_origin_id         = var.api_gateway_domain_name
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.managed_viewer_policy.id
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    viewer_protocol_policy   = "redirect-to-https"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = aws_acm_certificate.cert.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}
