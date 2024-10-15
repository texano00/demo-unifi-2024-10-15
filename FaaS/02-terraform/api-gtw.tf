# Create the API Gateway HTTP API
resource "aws_apigatewayv2_api" "http_crud_tutorial_api" {
  name          = "${local.resource_prefix}http-crud-tutorial-api"
  protocol_type = "HTTP"
}

# Create the Lambda Integration for the API Gateway
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.http_crud_tutorial_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.http_crud_tutorial_function.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

# Create the routes
resource "aws_apigatewayv2_route" "get_item_route" {
  api_id    = aws_apigatewayv2_api.http_crud_tutorial_api.id
  route_key = "GET /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "get_items_route" {
  api_id    = aws_apigatewayv2_api.http_crud_tutorial_api.id
  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "put_item_route" {
  api_id    = aws_apigatewayv2_api.http_crud_tutorial_api.id
  route_key = "PUT /items"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "delete_item_route" {
  api_id    = aws_apigatewayv2_api.http_crud_tutorial_api.id
  route_key = "DELETE /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Create a default stage for the API
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_crud_tutorial_api.id
  name        = "$default"
  auto_deploy = true
}

# Grant API Gateway permission to invoke the Lambda function
resource "aws_lambda_permission" "apigateway_lambda_permission" {
  statement_id  = "${local.resource_prefix}AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.http_crud_tutorial_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_crud_tutorial_api.execution_arn}/*/*"
}
