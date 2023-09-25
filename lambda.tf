data "archive_file" "lambdafunc" {
    type = "zip"
    source_file = "${var.lambda.source_file}"
    output_path = "${var.lambda.lambda_zip_location}"
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name    = var.lambda.function_name
  description      = "Example AWS Lambda using python with S3 trigger"
  handler          = var.lambda.handler
  runtime          = var.lambda.runtime
  source_path      = var.lambda.lambda_zip_location
  publish          = true

  layers = [
    module.lambda_layer_s3.lambda_layer_arn,
  ]
}

module "lambda_layer_s3" {
  source = "terraform-aws-modules/lambda/aws"

  create_layer = true

  layer_name          = "lambda-layer-s3"
  description         = "My amazing lambda layer (deployed from S3)"
  compatible_runtimes = [var.lambda.runtime]

  source_path = "build/python/lib/python3.10/site-packages"

  store_on_s3 = true
  s3_bucket   = "${module.s3_bucket_landing.s3_bucket_id}/${var.s3_bucket_landing.python_code}/"
}

resource "aws_s3_object" "upload-pandas" {
  bucket = "${module.s3_bucket_landing.s3_bucket_id}"
  key    = "${var.s3_bucket_landing.python_code}/${locals.pandas}"
  source = "${locals.pandas}"
}