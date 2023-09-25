###################################################
#         IAM
###################################################
data "aws_iam_policy_document" "glue_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["glue.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "s3_policy_document" {
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      module.s3_bucket_landing.s3_bucket_arn,
      "${module.s3_bucket_landing.s3_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_role" "glue_service_role" {
  name               = "glue-service-role"
  assume_role_policy = data.aws_iam_policy_document.glue_policy_document.json
}

resource "aws_iam_role_policy_attachment" "glue_service_role_policy_attachment" {
    role       = aws_iam_role.glue_service_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "glue_service_role_policy" {
  name   = "glue-service-role-policy"
  policy = data.aws_iam_policy_document.s3_policy_document.json
  role   = aws_iam_role.glue_service_role.id
}

###################################################
#         GLUE
###################################################

resource "aws_glue_job" "glue_data_transformation_job" {
  name              = "data-ingestion-job"
  role_arn          = aws_iam_role.glue_service_role.arn
  glue_version      = "3.0"
  number_of_workers = 1
  worker_type       = "G.1X"
  max_retries       = "1"
  timeout           = 2880

  command {
    name    = "glueetl"
    python_version = var.job-language
    script_location = "s3://${module.s3_bucket_landing.s3_bucket_id}/${var.s3_bucket_landing.python_code}/etl.py"
  }
  default_arguments = {
    "--TempDir"                           = "s3://${module.s3_bucket_landing.s3_bucket_id}/${var.s3_bucket_landing.temporary_directory}"
    "--enable-continuous-cloudwatch-log"  = "true"
    "--enable-metrics"                    = "true"
    "--extra-jars"                        = "s3://${module.s3_bucket_landing.s3_bucket_id}/${var.glue_jar.folder_path}/${var.glue_jar.spark},s3://${module.s3_bucket_landing.s3_bucket_id}/${var.glue_jar.folder_path}/${var.glue_jar.jdbc}"
  }
}