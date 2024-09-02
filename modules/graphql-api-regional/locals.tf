locals {
  custom_domain = var.dns != null && var.dns_zone != null
}
