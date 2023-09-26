###################################################
#         Bucket Outputs
###################################################

output "s3_landing_bucket_name" {
    value = module.s3_bucket_landing.s3_bucket_id
}

output "s3_landing_bucket_arn" {
    value = module.s3_bucket_landing.s3_bucket_arn
}

output "s3_bucket_landing_backup_name" {
    value = module.s3_bucket_landing_backup.s3_bucket_id
}

output "s3_bucket_landing_backup_arn" {
    value = module.s3_bucket_landing_backup.s3_bucket_arn
}

output "ss3_bucket_landing_transformed_name" {
    value = module.s3_bucket_landing_transformed.s3_bucket_id
}

output "s3_bucket_landing_transformed_arn" {
    value = module.s3_bucket_landing_transformed.s3_bucket_arn
}

###################################################
#         Lambda Outputs
###################################################

output "aws_lambda_function_name" {
    value = aws_lambda_function.s3_transform_function.id
}

output "aws_lambda_function_arn" {
    value = aws_lambda_function.s3_transform_function.arn
}

###################################################
#         Glue Outputs
###################################################

output "aws_glue_job_name" {
    value = aws_glue_job.glue_data_transformation_job.id
}

output "aws_glue_job_arn" {
    value = aws_glue_job.glue_data_transformation_job.arn
}

output "aws_glue_crawler_name" {
    value = aws_glue_crawler.streaming_crawler.id
}

output "aws_glue_crawler__arn" {
    value = aws_glue_crawler.streaming_crawler.arn
}
