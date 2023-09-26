###################################################
#         IAM
###################################################
data "aws_iam_policy_document" "glue_crawler_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["glue.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "glue_crawler_s3_policy_document" {
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [ 
        "arn:aws:s3:::${module.s3_bucket_landing_transformed.s3_bucket_id}/*",
        "arn:aws:s3:::${module.s3_bucket_landing_transformed.s3_bucket_id}", 
    ]
  }
}

resource "aws_iam_role" "glue_crawler_service_role" {
  name               = "glue-crawler-service-role"
  assume_role_policy = data.aws_iam_policy_document.glue_crawler_policy_document.json
}

resource "aws_iam_role_policy_attachment" "glue_crawler_service_role_policy_attachment" {
    role       = aws_iam_role.glue_crawler_service_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueCrawlerServiceRole"
}

resource "aws_iam_role_policy" "glue_crawler_service_role_policy" {
  name   = "glue-crawler-service-role-policy"
  policy = data.aws_iam_policy_document.glue_crawler_s3_policy_document.json
  role   = aws_iam_role.glue_crawler_service_role.id
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
  role            = aws_iam_role.glue_crawler_service_role.arn
  s3_target {
    path = module.s3_bucket_landing_transformed.s3_bucket_id
  }
}

