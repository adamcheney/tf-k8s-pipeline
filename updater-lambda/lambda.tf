locals {
  cluster_name = join("_", [
    var.eks_region,
    var.eks_short_name,
    "taupua",
    "com",
  ])
  environment_variables = merge(
    var.environment_variables,
    {
      "UPD_REGION"         = var.eks_region
      "UPD_LOCK_TABLE"     = aws_dynamodb_table.updater_lock_table.name
      "K8S_ENDPOINT_PARAM" = aws_ssm_parameter.eks_endpoint.name
      "K8S_CA_CERT_PARAM"  = aws_ssm_parameter.eks_ca_cert.name
      "KMS_KEY_ARN"        = var.kms_arn
      "CLUSTER_CLASS"      = var.cluster_class
      "CLUSTER_NAME"       = local.cluster_name
    }
  )
}

data "aws_ecr_repository" "lambda_ecr_repo" {
  name = var.lambda_ecr_repo
}

resource "aws_lambda_function" "k8s_updater_lambda" {
  provider      = aws
  function_name = "${var.lambda_name}-${var.cluster_short_uid}"
  description   = "K8s updater Lambda function"
  tags          = var.default_tags
  lifecycle {
    ignore_changes = [tags]
  }
  package_type = "Image"
  image_uri    = "${data.aws_ecr_repository.lambda_ecr_repo.repository_url}:latest"
  role         = var.updater_role_arn
  environment {
    variables = local.environment_variables
  }
}


resource "aws_lambda_permission" "allow_conf_s3_invoke" {
  provider      = aws
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.k8s_updater_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.pk8s_conf_arn
}

resource "aws_s3_bucket_notification" "conf_s3_notification" {
  provider = aws

  bucket = var.pk8s_conf_name
  lambda_function {
    lambda_function_arn = aws_lambda_function.k8s_updater_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "${var.config_k8s_yaml_prefix}/${var.cluster_class}"
    filter_suffix       = ".yaml"
  }
}

