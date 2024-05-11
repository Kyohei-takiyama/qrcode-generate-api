# Archive
data "archive_file" "layer_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../build/layer"
  output_path = "${path.module}/../../lambda/layer.zip"
}
data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../build/function"
  output_path = "${path.module}/../../lambda/function.zip"
}

#  Lambda Layer
resource "aws_lambda_layer_version" "labmda_layer" {
  filename         = data.archive_file.layer_zip.output_path
  source_code_hash = data.archive_file.layer_zip.output_base64sha256
  layer_name       = "${var.env_prefix}-${var.service_name}-layer"
}

resource "aws_lambda_function" "lambda_function" {
  function_name    = "${var.env_prefix}-${var.service_name}-lambda"
  role             = aws_iam_role.lambda_role.arn
  depends_on       = [aws_iam_role.lambda_role]
  handler          = "main.handler"
  runtime          = "python3.10"
  filename         = data.archive_file.function_zip.output_path
  source_code_hash = data.archive_file.function_zip.output_base64sha256
  layers           = [aws_lambda_layer_version.labmda_layer.arn]
}
