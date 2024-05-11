resource "aws_api_gateway_rest_api" "api" {
  name               = "${var.env_prefix}-${var.service_name}-api"
  binary_media_types = ["*/*"]
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "qrcode"
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id      = aws_api_gateway_rest_api.api.id
  resource_id      = aws_api_gateway_resource.root.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_function_uri
  depends_on              = [aws_api_gateway_method.api_method]

}


resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  depends_on  = [aws_api_gateway_rest_api.api]
  stage_name  = var.env_prefix
  triggers = {
    # resource "aws_lambda_function" "api" の内容が変わるごとにデプロイされるようにする
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.root.id,
      aws_api_gateway_method.api_method.id,
      aws_api_gateway_integration.integration.id,
    ]))
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_method_response" "response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.api_method.http_method
  status_code = "200"
  depends_on  = [aws_api_gateway_method.api_method]
}



resource "aws_lambda_permission" "api_gateway" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/${aws_api_gateway_method.api_method.http_method}/${aws_api_gateway_resource.root.path_part}"
}

# API Key
resource "aws_api_gateway_api_key" "api_key" {
  name = "${var.env_prefix}-${var.service_name}-api-key"
}

resource "aws_api_gateway_usage_plan" "usage_plan" {
  name       = "${var.env_prefix}-${var.service_name}-usage-plan"
  depends_on = [aws_api_gateway_api_key.api_key]
  api_stages {
    api_id = aws_api_gateway_rest_api.api.id
    stage  = aws_api_gateway_deployment.deployment.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "usage_plan_key" {
  key_id        = aws_api_gateway_api_key.api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan.id
}

data "aws_iam_policy_document" "api_gateway_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["execute-api:Invoke"]
    resources = ["${aws_api_gateway_rest_api.api.execution_arn}/*"]
  }
}

resource "aws_api_gateway_rest_api_policy" "policy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  policy      = data.aws_iam_policy_document.api_gateway_policy.json
}
