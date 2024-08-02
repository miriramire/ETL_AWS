resource "aws_api_gateway_rest_api" "apigateway" {
  name        = "globant-apigateway"
  description = "API Gateway"
}

resource "aws_api_gateway_resource" "apigateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  parent_id   = aws_api_gateway_rest_api.apigateway.root_resource_id
  path_part   = "apigateway"
}

resource "aws_api_gateway_method" "apigateway_method" {
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
  resource_id   = aws_api_gateway_resource.apigateway_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "apigateway_integration" {
  rest_api_id             = aws_api_gateway_rest_api.apigateway.id
  resource_id             = aws_api_gateway_resource.apigateway_resource.id
  http_method             = aws_api_gateway_method.apigateway_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_apigateway.invoke_arn
}

resource "aws_api_gateway_method_response" "apigateway_method_response" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.apigateway_resource.id
  http_method = aws_api_gateway_method.apigateway_method.http_method

  status_code = "200"
}

resource "aws_api_gateway_integration_response" "apigateway_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.apigateway_resource.id
  http_method = aws_api_gateway_method.apigateway_method.http_method

  status_code = aws_api_gateway_method_response.apigateway_method_response.status_code
}

resource "aws_api_gateway_deployment" "example_deployment" {
  depends_on = [aws_api_gateway_integration.apigateway_integration]
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  stage_name = "dev"
}