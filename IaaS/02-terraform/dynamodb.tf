resource "aws_dynamodb_table" "demo_table" {
  name         = "${local.resource_prefix}iaas-http-crud-tutorial-items"
  billing_mode = "PAY_PER_REQUEST" # PAY_PER_REQUEST is recommended for unpredictable workloads

  # Define the primary key schema
  hash_key = "id"

  # Attribute definition for the partition key
  attribute {
    name = "id"
    type = "S" # "S" stands for String
  }
}