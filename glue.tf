# IAM policy for the Glue role, granting necessary permissions.
data "aws_iam_policy_document" "glue_policy" {
    statement {
        effect = "Allow"
        actions = [
            "s3:ListBucket",
            "s3:GetObject",
            "s3:PutObject"
        ]
        resources = [
            "arn:aws:sqs:*:*:${var.s3_bucket_landing.name}",
            "arn:aws:sqs:*:*:${var.s3_bucket_landing.name}/*"
        ]
    }
    statement {
        effect = "Allow"
        actions = [ 
            "glue:CreateDatabase",
            "glue:CreateTable",
            "glue:BatchCreatePartition" 
        ]
        resources = [ "*" ]
    }
}

resource "aws_iam_role" "glue_role" {
  name = "glue-role"
  assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "glue.amazonaws.com"
        },
        "Action" = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_glue_job" "glue_data_transformation_job" {
  name     = "data-transformation-job"
  role_arn = aws_iam_role.glue_role.arn

  command {
    name    = "glueetl"
    python_version = "3"
    script_location = "s3://${var.s3_bucket_landing.name}/${var.s3_bucket_landing.python_code}/etl.py"
  }
}