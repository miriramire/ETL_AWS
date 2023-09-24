output "s3_landing_bucket_name" {
    value = module.s3_bucket_landing.s3_bucket_id
}

output "s3_landing_bucket_arn" {
    value = module.s3_bucket_landing.s3_bucket_arn
}
