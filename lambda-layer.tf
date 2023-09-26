locals {
  layer_zip_path    = "pandas_layer.zip"
  layer_name        = "my_lambda_requirements_layer"
  requirements_path = "requirements.txt"
}

# upload zip file to s3
resource "aws_s3_object" "lambda_layer_zip" {
  bucket = module.s3_bucket_landing.s3_bucket_id
  key = "${var.s3_bucket_landing.python_code}/${local.layer_zip_path}"
  source = local.layer_zip_path
}

# create lambda layer from s3 object
resource "aws_lambda_layer_version" "my-lambda-layer" {
  s3_bucket           = module.s3_bucket_landing.s3_bucket_id
  s3_key              = aws_s3_object.lambda_layer_zip.key
  layer_name          = local.layer_name
  compatible_runtimes = ["${var.lambda.runtime}"]
  skip_destroy        = true
}