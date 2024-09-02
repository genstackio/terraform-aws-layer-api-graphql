module "regional-api" {
  source   = "./modules/graphql-api-regional"

  name     = var.name
  dns      = var.dns
  dns_zone = var.dns_zone
}
