resource "aws_dynamodb_table" "updater_lock_table" {
  name           = "UpdaterNamespaceLocks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "namespace"
  attribute {
    name = "namespace"
    type = "S"
  }
  tags = var.default_tags
}
