###################################################
# Upload etl.py, JDBCS, and spark connector to S3 bucket
###################################################
resource "aws_s3_object" "upload-glue-script" {
  bucket = "${module.s3_bucket_landing.s3_bucket_id}"
  key = "${var.s3_bucket_landing.python_code}/${var.file-name}"
  source = "${var.file-name}"
}

resource "aws_s3_object" "upload-snowflake-jdbc" {
  bucket = "${module.s3_bucket_landing.s3_bucket_id}"
  key    = "${var.glue_jar.folder_path}/${var.glue_jar.jdbc}"
  source = "${var.glue_jar.jdbc}"
}

resource "aws_s3_object" "upload-snowflake-spark-connector" {
  bucket = "${module.s3_bucket_landing.s3_bucket_id}"
  key    = "${var.glue_jar.folder_path}/${var.glue_jar.spark}"
  source = "${var.glue_jar.spark}"
}

###################################################
#         LAMBDA trigger
###################################################

resource "aws_s3_bucket_notification" "s3_event_trigger" {
  bucket = var.s3_bucket_landing.name

  lambda_function {
    #lambda_function_arn = aws_lambda_function.s3_transform_function.arn
    lambda_function_arn = aws_lambda_function.s3_transform_function.arn
    events             = ["s3:ObjectCreated:*"]
    filter_suffix      = ".xlsx"
  }
}