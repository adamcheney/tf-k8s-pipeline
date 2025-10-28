data "aws_iam_policy_document" "syncer_lambda_assume_role_policydoc" {
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

data "aws_iam_policy_document" "syncer_lambda_access_pk8s_conf_policydoc" {
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

data "aws_iam_policy_document" "syncer_lambda_exec_policydoc" {
  # TODO: Add all the requisite permissions
  provider = aws
  statement {
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [
      var.updater_arn
    ]
  }
}

resource "aws_iam_policy" "syncer_lambda_access_pk8s_conf_policy" {
  provider    = aws
  name        = "kora-k8s-syncer-${var.cluster_short_uid}_S3Access"
  description = "IAM policy for K8s syncer Lambda execution"
  policy      = data.aws_iam_policy_document.syncer_lambda_access_pk8s_conf_policydoc.json
}

resource "aws_iam_policy" "syncer_lambda_k8s_exec_policy" {
  provider    = aws
  name        = "kora-k8s-syncer-${var.cluster_short_uid}_SyncerExec"
  description = "IAM policy for K8s syncer Lambda execution"
  policy      = data.aws_iam_policy_document.syncer_lambda_exec_policydoc.json
}

resource "aws_iam_role" "syncer_lambda_exec_role" {
  provider           = aws
  name               = "kora-k8s-syncer-${var.cluster_short_uid}_SyncerExec"
  description        = "IAM role for K8s syncer Lambda execution"
  assume_role_policy = data.aws_iam_policy_document.syncer_lambda_assume_role_policydoc.json
  tags               = var.default_tags
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_iam_role" "syncer_lambda_pk8s_conf_access_role" {
  provider           = aws
  name               = "kora-k8s-syncer-${var.cluster_short_uid}_S3Access"
  description        = "IAM role for K8s syncer Lambda pk8s-conf S3 access"
  assume_role_policy = data.aws_iam_policy_document.syncer_lambda_assume_role_policydoc.json
  tags               = var.default_tags
    lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_iam_role_policy_attachment" "syncer_lambda_exec_policy_attach" {
  provider   = aws
  role       = aws_iam_role.syncer_lambda_exec_role.name
  policy_arn = aws_iam_policy.syncer_lambda_k8s_exec_policy.arn
}

resource "aws_iam_role_policy_attachment" "syncer_lambda_access_pk8s_conf_policy_attach" {
  provider   = aws
  role       = aws_iam_role.syncer_lambda_exec_role.name
  policy_arn = aws_iam_policy.syncer_lambda_access_pk8s_conf_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  provider   = aws
  role       = aws_iam_role.syncer_lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
