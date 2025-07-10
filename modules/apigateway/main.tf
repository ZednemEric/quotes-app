variable "lambda_arns" {
  type = map(string)
}

variable "stage_name" {
  type = string
}

resource "aws_api_gateway_rest_api" "quotes" {
  name = "Quotes"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "put" {
  rest_api_id = aws_api_gateway_rest_api.quotes.id
  parent_id   = aws_api_gateway_rest_api.quotes.root_resource_id
  path_part   = "PutQuotes"
}

resource "aws_api_gateway_method" "put" {
  rest_api_id   = aws_api_gateway_rest_api.quotes.id
  resource_id   = aws_api_gateway_resource.put.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "put" {
  rest_api_id             = aws_api_gateway_rest_api.quotes.id
  resource_id             = aws_api_gateway_resource.put.id
  http_method             = aws_api_gateway_method.put.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = lambda_arns["put"]
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_resource" "get" {
  rest_api_id = aws_api_gateway_rest_api.quotes.id
  parent_id   = aws_api_gateway_rest_api.quotes.root_resource_id
  path_part   = "GetQuotes"
}

resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.quotes.id
  resource_id   = aws_api_gateway_resource.get.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get" {
  rest_api_id             = aws_api_gateway_rest_api.quotes.id
  resource_id             = aws_api_gateway_resource.get.id
  http_method             = aws_api_gateway_method.get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = lambda_arns["get"]
}

resource "aws_api_gateway_deployment" "quotes" {
  depends_on = [
    aws_api_gateway_integration.put,
    aws_api_gateway_integration.get
  ]
  rest_api_id = aws_api_gateway_rest_api.quotes.id
}

resource "aws_api_gateway_stage" "prod" {
  stage_name    = var.stage_name
  rest_api_id   = aws_api_gateway_rest_api.quotes.id
  deployment_id = aws_api_gateway_deployment.quotes.id
}

output "invoke_url" {
  value = "https://${aws_api_gateway_rest_api.quotes.id}.execute-api.${var.region}.amazonaws.com/${var.stage_name}"
}

