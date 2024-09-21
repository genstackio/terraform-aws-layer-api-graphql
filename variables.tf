variable "name" {
  type = string
}
variable "dns" {
  type    = string
  default = null
}
variable "dns_zone" {
  type    = string
  default = null
}
variable "user_pool_id" {
  type    = string
  default = null
}
