resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = {
    Name = "${var.project_name}-github-oidc"
  }
}

data "aws_iam_policy_document" "github_apply_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:thedevlake@202267354/k3s-observability-infrastructure@1451236571:ref:refs/heads/main"
      ]
    }
  }
}

resource "aws_iam_role" "github_apply" {
  name               = "${var.project_name}-${var.environment}-github-apply"
  assume_role_policy = data.aws_iam_policy_document.github_apply_trust.json

  tags = {
    Name = "${var.project_name}-${var.environment}-github-apply"
  }
}
