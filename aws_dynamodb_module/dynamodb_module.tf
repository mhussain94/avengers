resource "aws_dynamodb_table" "avengers_table" {
  name           = "avengers_table"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "url"

  attribute {
    name = "url"
    type = "S"
  }

  attribute {
    name = "error_count"
    type = "N"
  }

  global_secondary_index {
    name               = "error_count"
    hash_key           = "error_count"
    projection_type    = "ALL"
    write_capacity     = 5
    read_capacity      = 5
  }
}

output "dynamo_db_arn" {
  value="${aws_dynamodb_table.avengers_table.arn}"
}

output "dynamodb_name" {
  value="${aws_dynamodb_table.avengers_table.name}"
}

output "dynamodb_hash_key" {
  value="${aws_dynamodb_table.avengers_table.hash_key}"
}