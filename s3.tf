###################################################
#         Landing Bucket
###################################################
module "s3_bucket_landing" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.s3_bucket_landing.name
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"
}

resource "aws_s3_object" "employees_folder" {
  bucket = module.s3_bucket_landing.s3_bucket_id
  key    = "${var.s3_bucket_landing.employees}/"
}

resource "aws_s3_object" "departments_folder" {
  bucket = module.s3_bucket_landing.s3_bucket_id
  key    = "${var.s3_bucket_landing.departments}/"
}

resource "aws_s3_object" "jobs_folder" {
  bucket = module.s3_bucket_landing.s3_bucket_id
  key    = "${var.s3_bucket_landing.jobs}/"
}

resource "aws_s3_object" "python_code_folder" {
  bucket = module.s3_bucket_landing.s3_bucket_id
  key    = "${var.s3_bucket_landing.python_code}/"
}

resource "aws_s3_object" "temporary_directory" {
  bucket = module.s3_bucket_landing.s3_bucket_id
  key    = "${var.s3_bucket_landing.temporary_directory}/"
}

resource "aws_s3_object" "hlue_jar" {
  bucket = module.s3_bucket_landing.s3_bucket_id
  key    = "${var.glue_jar.folder_path}/"
}

###################################################
#         Transformed files Bucket
###################################################

module "s3_bucket_landing_transformed" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.s3_bucket_landing.name}-transformed"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"
}

resource "aws_s3_object" "employees_folder_transformed" {
  bucket = module.s3_bucket_landing_transformed.s3_bucket_id
  key    = "${var.s3_bucket_landing.employees}/"
}

resource "aws_s3_object" "departments_folder_transformed" {
  bucket = module.s3_bucket_landing_transformed.s3_bucket_id
  key    = "${var.s3_bucket_landing.departments}/"
}

resource "aws_s3_object" "jobs_folder_transformed" {
  bucket = module.s3_bucket_landing_transformed.s3_bucket_id
  key    = "${var.s3_bucket_landing.jobs}/"
}

###################################################
#         Table's backup 
###################################################

module "s3_bucket_landing_backup" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.s3_bucket_landing.name}-backup"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"
}