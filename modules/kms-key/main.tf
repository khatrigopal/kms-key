variable "key_alias" {
  description = "The alias to associate with the KMS key"
  type        = string
}



data "aws_iam_policy_document" "kms_policy" {
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "kms:*"
    ]

    resources = [
      aws_kms_key.kms_key.arn
    ]
  }
}

resource "aws_kms_key" "kms_key" {
  description             = "KMS key for encrypting sensitive data"
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_policy.json
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
