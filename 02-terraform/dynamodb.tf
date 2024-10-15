resource "aws_dynamodb_table" "http_crud_tutorial_items" {
  name         = "${local.resource_prefix}http-crud-tutorial-items"
  billing_mode = "PAY_PER_REQUEST" # PAY_PER_REQUEST is recommended for unpredictable workloads

  # Define the primary key schema
  hash_key = "id"

  # Attribute definition for the partition key
  attribute {
    name = "id"
    type = "S" # "S" stands for String
  }
}