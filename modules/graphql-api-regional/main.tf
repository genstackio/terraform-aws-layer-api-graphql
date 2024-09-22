data aws_region "current" {
}

resource "aws_appsync_graphql_api" "regional" {
  authentication_type = var.user_pool_id != null ? "AMAZON_COGNITO_USER_POOLS" : "API_KEY"
  name                = var.name

  schema = var.schema

  dynamic "user_pool_config" {
    for_each = var.user_pool_id != null ? {k: { user_pool_id = var.user_pool_id }} : {}
    content {
      aws_region     = data.aws_region.current.name
      default_action = "DENY"
      user_pool_id   = user_pool_config.value.user_pool_id
    }
  }

  #lifecycle {
  #  ignore_changes = [schema]
  #}
}

resource "aws_appsync_domain_name" "regional" {
  count           = local.custom_domain ? 1 : 0
  domain_name     = var.dns
  certificate_arn = aws_acm_certificate.cert[0].arn
}

resource "aws_appsync_domain_name_api_association" "regional" {
  count       = local.custom_domain ? 1 : 0
  api_id      = aws_appsync_graphql_api.regional.id
  domain_name = aws_appsync_domain_name.regional[0].domain_name
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
  name    = element(tolist(aws_acm_certificate.cert[0].domain_validation_options), 0).resource_record_name
  type    = element(tolist(aws_acm_certificate.cert[0].domain_validation_options), 0).resource_record_type
  zone_id = var.dns_zone
  records = [element(tolist(aws_acm_certificate.cert[0].domain_validation_options), 0).resource_record_value]
  ttl     = 60
}
resource "aws_acm_certificate_validation" "cert" {
  count                   = local.custom_domain ? 1 : 0
  provider                = aws.acm
  certificate_arn         = aws_acm_certificate.cert[0].arn
  validation_record_fqdns = [aws_route53_record.cert_validation[0].fqdn]
}
