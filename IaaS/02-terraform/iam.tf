resource "aws_iam_role" "ec2_role" {
  name = "${local.resource_prefix}-ec2-dynamodb-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "dynamodb_access_policy" {
  name        = "${local.resource_prefix}DynamoDBAccessPolicy"
  description = "Policy to allow EC2 instance to access DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_policy" {
  name       = "${local.resource_prefix}-dynamodb-policy-attachment"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}
