output "arn" {
  value = aws_appsync_graphql_api.regional.arn
}
output "name" {
  value = aws_appsync_graphql_api.regional.name
}
output "id" {
  value = aws_appsync_graphql_api.regional.id
}
output "endpoint" {
  value = "https://${aws_appsync_domain_name.regional.domain_name}/graphql"
}
