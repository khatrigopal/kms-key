resource "aws_iam_role" "kms_role" {
  name = "my-kms-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "kms.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    effect = "Allow"

    principals {
      identifiers = [aws_iam_role.kms_role.arn]
      type        = "AWS"
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
    ]

    resources = [
      aws_kms_key.my_key.arn,
      aws_kms_key.my_key.arn+":*",
    ]
  }
}

resource "aws_kms_key" "my_key" {
  description = "My KMS key"
  policy      = jsonencode(data.aws_iam_policy_document.kms_key_policy.json)
}
