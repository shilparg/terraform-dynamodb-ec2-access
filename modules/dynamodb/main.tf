resource "aws_dynamodb_table" "bookinventory" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ISBN"
  range_key    = "Genre"

  attribute {
    name = "ISBN"
    type = "S"
  }

  attribute {
    name = "Genre"
    type = "S"
  }

  tags = {
    Name = "BookInventory"
  }
}