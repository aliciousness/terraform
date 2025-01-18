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

variable "cache_cluster_size" {
  description = "The size of the cache cluster"
  type        = string
  default     = "0.5"
}

variable "cache_cluster_enabled" {
  description = "Whether the cache cluster is enabled"
  type        = bool
  default     = false
}

variable "cache_ttl_in_seconds" {
  description = "The time-to-live for the cache"
  type        = number
  default     = 3600
}

variable "metrics_enabled" {
  description = "Whether metrics are enabled"
  type        = bool
  default     = false
}

variable "logging_level" {
  description = "The logging level for the API Gateway"
  type        = string
  default     = "OFF"
}

variable "throttling_rate_limit" {
  description = "The rate limit for the API Gateway"
  type        = number
  default     = 5
}

variable "throttling_burst_limit" {
  description = "The burst limit for the API Gateway"
  type        = number
  default     = 10
}

variable "usage_plan_quota_limit" {
  description = "The quota limit for the usage plan"
  type        = number
  default     = 500
}

variable "usage_plan_quota_period" {
  description = "The period for the usage plan"
  type        = string
  default     = "MONTH"
}

variable "usage_plan_throttle_rate_limit" {
  description = "The throttle rate limit for the usage plan"
  type        = number
  default     = 2
}

variable "usage_plan_throttle_burst_limit" {
  description = "The throttle burst limit for the usage plan"
  type        = number
  default     = 5
}

variable "cloudwatch_retention_in_days" {
  description = "The number of days to retain logs in CloudWatch"
  type        = number
  default     = 14
}

variable "waf_scope" {
  description = "The scope for the WAF"
  type        = string
  default     = "REGIONAL"
}

variable "enable_waf" {
  description = "Whether to enable the WAF"
  type        = bool
  default     = false
}
