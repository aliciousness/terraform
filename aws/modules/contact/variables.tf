variable "memory_size" {
  description = "The amount of memory to allocate to the Lambda function"
  type        = number
  default     = 256
}

variable "lambda_timeout" {
  description = "The amount of time the Lambda function has to run"
  type        = number
  default     = 30
}

variable "telegram_bot_token" {
  description = "The token for the Telegram bot"
  type        = string
}

variable "telegram_chat_id" {
  description = "The chat ID of the Telegram channel"
  type        = string
}

variable "application" {
  description = "The name of the application"
  type        = string
  validation {
    condition     = length(var.application) > 0
    error_message = "The application name must not be empty"
  }
  validation {
    condition     = length(var.application) < 28
    error_message = "The application name must be less than 28 characters"
  }
}

variable "environment" {
  description = "The environment for the application"
  type        = string
}

variable "terraform_tags" {
  description = "The tags to apply to all resources"
  type        = map(string)
}

variable "vpc" {
  description = "The VPC configuration"
  type        = any
}

variable "custom_header_value" {
  description = "The value for the custom header"
  type        = string
  default     = ""
}
