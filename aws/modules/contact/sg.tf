resource "aws_security_group" "lambda_egress" {
  name        = "${local.name}-lambda_egress"
  description = "Allow all egress traffic from lambda"
  vpc_id      = var.vpc.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}
