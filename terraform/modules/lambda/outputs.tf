output "lambda_function_name" {
  value = aws_lambda_function.lambda_function.function_name
}

output "lambda_function_uri" {
  value = aws_lambda_function.lambda_function.invoke_arn
}
