resource "aws_lambda_function" "lambda" {
  function_name = "${local.name}-lambda"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_role.arn
  filename      = "lambda_function.zip"
  memory_size   = var.memory_size
  timeout       = var.lambda_timeout

  source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")

  vpc_config {
    subnet_ids         = var.vpc.subnet_ids
    security_group_ids = [aws_security_group.lambda_egress.id]
  }

  environment {
    variables = {
      TELEGRAM_BOT_TOKEN = var.telegram_bot_token
      TELEGRAM_CHAT_ID   = var.telegram_chat_id
      APPLICATION_NAME   = var.application
    }
  }
}

resource "aws_lambda_function" "authorizer" {
  function_name = "${local.name}-lambda-authorizer"
  handler       = "authorizer.lambda_handler"
  runtime       = "python3.8"
  role          = aws_iam_role.authorizer_role.arn
  filename      = "authorizer.zip"
  memory_size   = 128
  timeout       = 5

  source_code_hash = filebase64sha256("${path.module}/authorizer.zip")

  vpc_config {
    subnet_ids         = var.vpc.subnet_ids
    security_group_ids = [aws_security_group.lambda_egress.id]
  }

  environment {
    variables = {
      APPLICATION_NAME = var.application
    }
  }
}

