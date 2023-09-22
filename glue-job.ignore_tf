resource "aws_glue_job" "glue-job" {
  name = "${var.job-name}"
  role_arn = "${var.glue-arn}"
  description = "This is script to load data into redshift"
  max_retries = "1"
  timeout = 2880
  command {
    script_location = "s3://${var.s3_bucket_landing.name}/${var.s3_bucket_landing.python_code}/${var.file-name}"
    python_version = "3"
  }
  execution_property {
    max_concurrent_runs = 1
  }
  glue_version = "3.0"
}