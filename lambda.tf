data "archive_file" "lambdafunc" {
    type = "zip"
    source_file = "${var.lambda.source_file}"
    output_path = "${var.lambda.lambda_zip_location}"
}

resource "aws_lambda_function" "s3_transform_function" {
  function_name    = var.lambda.function_name
  description      = "Example AWS Lambda using python with S3 trigger"
  handler          = var.lambda.handler
  runtime          = var.lambda.runtime
  filename         = var.lambda.lambda_zip_location

  role          = "${aws_iam_role.lambda_role.arn}"
  source_code_hash = filebase64sha256("${var.lambda.lambda_zip_location}")

  layers = [aws_lambda_layer_version.my-lambda-layer.arn]
}

resource "aws_lambda_permission" "test" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.s3_transform_function.function_name}"
  principal = "s3.amazonaws.com"
  source_arn = "arn:aws:s3:::${var.s3_bucket_landing.name}"
}