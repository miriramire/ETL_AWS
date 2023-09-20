# S3 Landing Bucket
module "s3_bucket_landing" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.s3_bucket_landing.name
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"
}

resource "aws_s3_object" "employees_folder" {
  bucket = var.s3_bucket_landing.name
  key    = "${var.s3_bucket_landing.employees}/"
}

resource "aws_s3_object" "departments_folder" {
  bucket = var.s3_bucket_landing.name
  key    = "${var.s3_bucket_landing.departments}/"
}

resource "aws_s3_object" "jobs_folder" {
  bucket = var.s3_bucket_landing.name
  key    = "${var.s3_bucket_landing.jobs}/"
}

resource "aws_s3_object" "tranformed_folder" {
  bucket = var.s3_bucket_landing.name
  key    = "${var.s3_bucket_landing.tranformed}/"
}

resource "aws_s3_object" "python_code_folder" {
  bucket = var.s3_bucket_landing.name
  key    = "${var.s3_bucket_landing.python_code}/"
}

# S3 Landing Bucket Backup
module "s3_bucket_landing_backup" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.s3_bucket_landing.name}-backup"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"
}

resource "aws_s3_object" "employees_folder_backup" {
  bucket = module.s3_bucket_landing_backup.s3_bucket_id
  key    = "${var.s3_bucket_landing.employees}/"
}

resource "aws_s3_object" "departments_folde_backup" {
  bucket = module.s3_bucket_landing_backup.s3_bucket_id
  key    = "${var.s3_bucket_landing.departments}/"
}

resource "aws_s3_object" "jobs_folder_backup" {
  bucket = module.s3_bucket_landing_backup.s3_bucket_id
  key    = "${var.s3_bucket_landing.jobs}/"
}