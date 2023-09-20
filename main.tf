# Upload etl.py code to S3 bucket
resource "aws_s3_object" "upload-glue-script" {
  bucket = "${var.s3_bucket_landing.name}"
  key = "${var.s3_bucket_landing.python_code}/${var.file-name}"
  source = "${var.file-name}"
}