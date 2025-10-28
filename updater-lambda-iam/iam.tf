data "aws_iam_policy_document" "updater_lambda_assume_role_policydoc" {
  provider = aws
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "updater_lambda_access_pk8s_conf_policydoc" {
  provider = aws
  statement {
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${var.pk8s_conf_arn}/*"
    ]
  }
  statement {
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      var.kms_arn
    ]
  }
}

data "aws_iam_policy_document" "updater_lambda_k8s_exec_policydoc" {
  # TODO: Add all the requisite permissions
  provider = aws
  statement {
    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters",
      "eks:UpdateClusterConfig",
      "eks:ListUpdates",
      "eks:DescribeUpdate",
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = [
      var.lock_table_arn
    ]
  }
  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParameterHistory"
    ]
    resources = [
      var.eks_endpoint_param_arn,
      var.eks_ca_cert_param_arn
    ]
  }
}

resource "aws_iam_policy" "updater_lambda_access_pk8s_conf_policy" {
  provider    = aws
  name        = "kora-k8s-updater-${var.cluster_short_uid}_S3Access"
  description = "IAM policy for K8s updater Lambda execution"
  policy      = data.aws_iam_policy_document.updater_lambda_access_pk8s_conf_policydoc.json
}

resource "aws_iam_policy" "updater_lambda_k8s_exec_policy" {
  provider    = aws
  name        = "kora-k8s-updater-${var.cluster_short_uid}_UpdaterExec"
  description = "IAM policy for K8s updater Lambda execution"
  policy      = data.aws_iam_policy_document.updater_lambda_k8s_exec_policydoc.json
}

resource "aws_iam_role" "updater_lambda_exec_role" {
  provider           = aws
  name               = "kora-k8s-updater-${var.cluster_short_uid}_UpdaterExec"
  description        = "IAM role for K8s updater Lambda execution"
  assume_role_policy = data.aws_iam_policy_document.updater_lambda_assume_role_policydoc.json
  tags               = var.default_tags
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_iam_role" "updater_lambda_pk8s_conf_access_role" {
  provider           = aws
  name               = "kora-k8s-updater-${var.cluster_short_uid}_S3Access"
  description        = "IAM role for K8s updater Lambda pk8s-conf S3 access"
  assume_role_policy = data.aws_iam_policy_document.updater_lambda_assume_role_policydoc.json
  tags               = var.default_tags
    lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_iam_role_policy_attachment" "updater_lambda_exec_policy_attach" {
  provider   = aws
  role       = aws_iam_role.updater_lambda_exec_role.name
  policy_arn = aws_iam_policy.updater_lambda_k8s_exec_policy.arn
}

resource "aws_iam_role_policy_attachment" "updater_lambda_access_pk8s_conf_policy_attach" {
  provider   = aws
  role       = aws_iam_role.updater_lambda_exec_role.name
  policy_arn = aws_iam_policy.updater_lambda_access_pk8s_conf_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  provider   = aws
  role       = aws_iam_role.updater_lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
