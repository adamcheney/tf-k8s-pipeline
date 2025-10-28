locals {
  environment_variables = merge(
    var.environment_variables,
    {
      "UPD_REGION"  = var.eks_region
      "KMS_KEY_ARN" = var.kms_arn
      "UPDATER_ARN" = var.updater_arn
    }
  )
}

data "aws_ecr_repository" "lambda_ecr_repo" {
  name = var.lambda_ecr_repo
}

# resource "aws_lambda_function" "k8s_syncer_lambda" {
#   provider      = aws
#   function_name = "${var.lambda_name}-${var.cluster_short_uid}"
#   description   = "K8s syncer Lambda function"
#   tags          = var.default_tags
#   lifecycle {
#     ignore_changes = [tags]
#   }
#   handler      = "k8s-syncer.lambda_handler"
#   role         = var.syncer_role_arn
#   image_uri    = data.aws_ecr_repository.lambda_ecr_repo.repository_url
#   package_type = "Image"
#   environment {
#     variables = local.environment_variables
#   }
# }
