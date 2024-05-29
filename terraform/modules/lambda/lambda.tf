data "aws_ecr_image" "api_image" {
  repository_name = var.image_repo_name
  most_recent     = true
}

resource "aws_lambda_function" "lambda_function" {
  depends_on    = [aws_iam_role.lambda_role]
  function_name = "${var.env_prefix}-${var.service_name}-lambda"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = data.aws_ecr_image.api_image.image_uri
  timeout       = 30
}
