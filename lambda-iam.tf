resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_s3_policy.json
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_policy.json
}

data "aws_iam_policy_document" "lambda_s3_policy" {
  statement {
    effect = "Allow"
    actions = [
        "logs:PutLogEvents",
        "logs:CreateLogGroup",
        "logs:CreateLogStream"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
  statement {
    effect = "Allow"
    actions = [ "s3:*" ]
    resources = [ 
        "arn:aws:s3:::${module.s3_bucket_landing.s3_bucket_id}/*",
        "arn:aws:s3:::${module.s3_bucket_landing.s3_bucket_id}",
        "arn:aws:s3:::${module.s3_bucket_landing_transformed.s3_bucket_id}/*",
        "arn:aws:s3:::${module.s3_bucket_landing_transformed.s3_bucket_id}", 
    ]
  }
  statement {
    effect = "Allow"
    actions = ["glue:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lambda_assume_policy" {
    statement {
      effect = "Allow"
      actions = [ "sts:AssumeRole" ]
      principals {
        type = "Service"
        identifiers = [ "lambda.amazonaws.com" ]
      }
    }
}