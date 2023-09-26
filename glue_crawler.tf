###################################################
#         IAM
###################################################
resource "aws_iam_role" "glue_crawler_role" {
  name = "glue-crawler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "glue_crawler_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  role       = aws_iam_role.glue_crawler_role.name
}

###################################################
#         Glue Crawler
###################################################
# AWS Glue database
resource "aws_glue_catalog_database" "streaming_database" {
  name = var.glue_crawler.database_name
}

# AWS Glue Crawler
resource "aws_glue_crawler" "streaming_crawler" {
  database_name   = aws_glue_catalog_database.streaming_database.name
  name            = var.glue_crawler.crawler_name
  role            = aws_iam_role.glue_crawler_role.arn
  s3_target {
    path = module.s3_bucket_landing_transformed.s3_bucket_id
  }
}

