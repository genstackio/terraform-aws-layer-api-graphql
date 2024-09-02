resource "aws_appsync_graphql_api" "regional" {
  authentication_type = "API_KEY"
  name                = var.name
}
