resource "aws_appsync_graphql_api" "regional" {
  authentication_type = "API_KEY"
  name                = var.name
}

resource "aws_appsync_domain_name" "regional" {
  count           = local.custom_domain ? 1 : 0
  domain_name     = var.dns
  certificate_arn = aws_acm_certificate.cert[0].arn
}

resource "aws_appsync_domain_name_api_association" "example" {
  count       = local.custom_domain ? 1 : 0
  api_id      = aws_appsync_graphql_api.regional.id
  domain_name = aws_appsync_domain_name.regional.domain_name
}

resource "aws_acm_certificate" "cert" {
  count             = local.custom_domain ? 1 : 0
  domain_name       = var.dns
  validation_method = "DNS"
  provider          = aws.acm
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  count             = local.custom_domain ? 1 : 0
  name    = element(tolist(aws_acm_certificate.cert.domain_validation_options), 0).resource_record_name
  type    = element(tolist(aws_acm_certificate.cert.domain_validation_options), 0).resource_record_type
  zone_id = var.dns_zone
  records = [element(tolist(aws_acm_certificate.cert.domain_validation_options), 0).resource_record_value]
  ttl     = 60
}
resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.acm
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
