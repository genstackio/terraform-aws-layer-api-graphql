module "regional-api" {
  source       = "./modules/graphql-api-regional"

  name         = var.name
  dns          = var.dns
  dns_zone     = var.dns_zone
  user_pool_id = var.user_pool_id
  schema       = var.schema

  providers    = {
    aws     = aws
    aws.acm = aws.acm
  }
}
