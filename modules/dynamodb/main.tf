resource "aws_dynamodb_table" "quotes" {
  name           = "Quotes"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1

  hash_key       = "quote"
  range_key      = "author"

  attribute {
    name = "quote"
    type = "S"
  }

  attribute {
    name = "author"
    type = "S"
  }

  table_class = "STANDARD"

  server_side_encryption {
    enabled = true
  }
}

resource "aws_appautoscaling_target" "read" {
  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.quotes.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "read_policy" {
  name               = "ReadAutoScaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.read.resource_id
  scalable_dimension = aws_appautoscaling_target.read.scalable_dimension
  service_namespace  = aws_appautoscaling_target.read.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value       = 20.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_target" "write" {
  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.quotes.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "write_policy" {
  name               = "WriteAutoScaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.write.resource_id
  scalable_dimension = aws_appautoscaling_target.write.scalable_dimension
  service_namespace  = aws_appautoscaling_target.write.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value       = 20.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

output "table_name" {
  value = aws_dynamodb_table.quotes.name
}

