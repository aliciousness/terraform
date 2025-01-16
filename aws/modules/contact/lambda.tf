resource "aws_lambda_function" "lambda" {
  function_name = "${local.name}-lambda"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/lambda_function.zip"
  memory_size   = var.memory_size
  timeout       = var.lambda_timeout

  source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")

  vpc_config {
    subnet_ids         = var.vpc.private_subnets
    security_group_ids = [aws_security_group.lambda_egress.id]
  }

  environment {
    variables = {
      APPLICATION_NAME       = var.application
      CORS_ALLOWED_ORIGINS   = local.lambda_response_headers["Access-Control-Allow-Origin"]
      CORS_ALLOWED_HEADERS   = local.lambda_response_headers["Access-Control-Allow-Headers"]
      CORS_ALLOWED_METHODS   = local.lambda_response_headers["Access-Control-Allow-Methods"]
      CORS_ALLOW_CREDENTIALS = local.lambda_response_headers["Access-Control-Allow-Credentials"]
    }
  }
}

resource "aws_lambda_function" "authorizer" {
  function_name = "${local.name}-lambda-authorizer"
  handler       = "authorizer.lambda_handler"
  runtime       = "python3.8"
  role          = aws_iam_role.authorizer_role.arn
  filename      = "${path.module}/authorizer.zip"
  memory_size   = 128
  timeout       = 5

  source_code_hash = filebase64sha256("${path.module}/authorizer.zip")

  vpc_config {
    subnet_ids         = var.vpc.private_subnets
    security_group_ids = [aws_security_group.lambda_egress.id]
  }

  environment {
    variables = {
      APPLICATION_NAME = var.application
    }
  }
}

resource "aws_lambda_function" "tokenizer" {
  function_name = "${local.name}-lambda-tokenizer"
  handler       = "tokenizer.lambda_handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/tokenizer.zip"
  memory_size   = 128
  timeout       = 5

  source_code_hash = filebase64sha256("${path.module}/tokenizer.zip")

  vpc_config {
    subnet_ids         = var.vpc.private_subnets
    security_group_ids = [aws_security_group.lambda_egress.id]
  }

  environment {
    variables = {
      APPLICATION_NAME = var.application
    }
  }

}
