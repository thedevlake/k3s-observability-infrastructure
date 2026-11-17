locals {
  terraform_state_bucket = "k3s-observability-tfstate-520728855361-eu-west-1"

  terraform_state_key = "infrastructure/networking/terraform.tfstate"

  terraform_state_lock_key = "${local.terraform_state_key}.tflock"
}

data "aws_iam_policy_document" "github_apply_permissions" {
  statement {
    sid       = "ListNetworkingTerraformState"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${local.terraform_state_bucket}"]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values = [
        local.terraform_state_key,
        local.terraform_state_lock_key
      ]
    }
  }

  statement {
    sid    = "ManageNetworkingTerraformState"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${local.terraform_state_bucket}/${local.terraform_state_key}"
    ]
  }

  statement {
    sid    = "ManageNetworkingTerraformStateLock"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::${local.terraform_state_bucket}/${local.terraform_state_lock_key}"
    ]
  }
}

resource "aws_iam_role_policy" "github_apply_backend" {
  name   = "${var.project_name}-github-apply-backend"
  role   = aws_iam_role.github_apply.id
  policy = data.aws_iam_policy_document.github_apply_permissions.json
}
