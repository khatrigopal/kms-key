variable "key_alias" {
  description = "The alias to associate with the KMS key"
  type        = string
}



data "aws_iam_policy_document" "kms" {
  # Allow root users full management access to key
  statement {
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  # Allow other accounts limited access to key
  statement {
    effect = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    resources = ["*"]

    # AWS account IDs that need access to this key
    principals {
      type        = "AWS"
      identifiers = data.aws_caller_identity.current.account_id
    }
  }
}
resource "aws_kms_key" "kms_key" {
  description             = "KMS key for encrypting sensitive data"
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms.json
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "kms_key_alias" {
  name          = var.key_alias
  target_key_id = aws_kms_key.kms_key.key_id
}

output "kms_key_id" {
  description = "The ID of the KMS key created by the module"
  value       = aws_kms_key.kms_key.key_id
}
