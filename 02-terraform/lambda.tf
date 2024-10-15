# IAM Role for Lambda
resource "aws_iam_role" "http_crud_tutorial_role" {
  name = "${local.resource_prefix}http-crud-tutorial-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Simple Microservice Permissions
resource "aws_iam_policy" "simple_microservice_policy" {
  name = "${local.resource_prefix}simple_microservice_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_policy_attachment" "http_crud_tutorial_policy_attachment" {
  name       = "${local.resource_prefix}http-crud-tutorial-policy-attachment"
  roles      = [aws_iam_role.http_crud_tutorial_role.name]
  policy_arn = aws_iam_policy.simple_microservice_policy.arn
}

# Attach the AWSLambdaBasicExecutionRole managed policy to the IAM role
resource "aws_iam_policy_attachment" "lambda_basic_execution" {
  name       = "${local.resource_prefix}lambda-basic-execution-attachment"
  roles      = [aws_iam_role.http_crud_tutorial_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "/@£$"
}

# Create the Lambda function
resource "aws_lambda_function" "http_crud_tutorial_function" {
  filename      = "lambda/1.0.1/main.zip" # Path to your local ZIP file
  function_name = "${local.resource_prefix}http-crud-tutorial-function"
  role          = aws_iam_role.http_crud_tutorial_role.arn
  handler       = "main.lambda_handler" # Update this to your handler function name
  runtime       = "python3.9"           # Choose your runtime, e.g., nodejs18.x or python3.9
  
  # source_code_hash = filebase64sha256("lambda/1.0.0/main.zip")
  source_code_hash = random_string.random.result

  # Optional: Environment variables
  environment {
    variables = {
      DYNAMODB_TABLE_NAME = aws_dynamodb_table.http_crud_tutorial_items.name
    }
  }
}

# Optional: Add permissions for API Gateway or other services to invoke the Lambda function
resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.http_crud_tutorial_function.function_name
  principal     = "apigateway.amazonaws.com"
}
