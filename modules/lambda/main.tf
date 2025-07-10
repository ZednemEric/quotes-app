variable "table_name" {
  type = string
}

resource "aws_iam_role" "put" {
  name = "PutQuotesRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "put_policy" {
  name = "PutPolicy"
  role = aws_iam_role.put.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = ["dynamodb:PutItem"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "put" {
  function_name = "PutQuotes"
  filename      = "${path.module}/put_quotes.zip"
  handler       = "put_quotes.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.put.arn
  timeout       = 60

  environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }
}

resource "aws_iam_role" "get" {
  name = "GetQuotesRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "get_policy" {
  name = "GetPolicy"
  role = aws_iam_role.get.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = ["dynamodb:Scan"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "get" {
  function_name = "GetQuotes"
  filename      = "${path.module}/get_quotes.zip"
  handler       = "get_quotes.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.get.arn
  timeout       = 60

  environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }
}

output "put_lambda_arn" {
  value = aws_lambda_function.put.arn
}

output "get_lambda_arn" {
  value = aws_lambda_function.get.arn
}

