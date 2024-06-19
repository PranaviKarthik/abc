provider "aws" {
  region = "ap-south-1"
}

# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

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

  tags = {
    Name = "lambda-exec-role"
  }
}

resource "aws_iam_policy_attachment" "lambda_exec_policy" {
  name       = "lambda_exec_policy_attachment"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function
resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  timeout       = 10

  filename = "Lambda_function.zip"  # Ensure to use the correct path to your zip file
  source_code_hash = filebase64sha256("Lambda_function.zip")  # Ensure to use the correct path to your zip file

  tags = {
    Name = "my-lambda-function"
  }
}

output "lambda_function_arn" {
  value = aws_lambda_function.my_lambda.arn
}
