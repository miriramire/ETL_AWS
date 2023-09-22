# Upload etl.py code to S3 bucket
resource "aws_s3_object" "upload-glue-script" {
  bucket = "${var.s3_bucket_landing.name}"
  key = "${var.s3_bucket_landing.python_code}/${var.file-name}"
  source = "${var.file-name}"
}

###################################################
#         LAMBDA trigger
###################################################

resource "aws_s3_bucket_notification" "s3_event_trigger" {
  bucket = var.s3_bucket_landing.name

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_transform_function.arn
    events             = ["s3:ObjectCreated:*"]
    filter_prefix      = "${var.s3_bucket_landing.input}"
    filter_suffix      = ""
  }
}