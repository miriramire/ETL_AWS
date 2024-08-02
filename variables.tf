###################################################
#         Bucket VARIABLES
###################################################
variable "s3_bucket_landing" {
  description = "External data will be received in input folder"
  type = object({
    name                = string
    employees           = string
    departments         = string
    jobs                = string
    python_code         = string
    temporary_directory = string
  })

  default = {
    name                = "landing-globant-data-terraform-project-101"
    employees           = "employees"
    departments         = "departments"
    jobs                = "jobs"
    python_code         = "python"
    temporary_directory = "glue-temporary-directory"
  }
}

###################################################
#         LAMBDA VARIABLES
###################################################

variable "lambda" {
  description = "Lambda details"
  type = object({
    source_file         = string
    function_name       = string
    handler             = string
    lambda_zip_location = string
    runtime             = string
    pandas              = string
  })

  default = {
    source_file         = "lambdafunc.py"
    function_name       = "lambdafunc"
    handler             = "lambdafunc.lambda_handler"
    lambda_zip_location = "outputs/lambdafunc.zip"
    runtime             = "python3.10"
    pandas              = "pandas_layer.zip"
  }
  
}

variable "lambda_apigateway" {
  type = object({
    source_file         = string
    function_name       = string
    handler             = string
    lambda_zip_location = string
    runtime             = string
  })

  default = {
    source_file         = "apigateway.py"
    function_name       = "apigateway"
    handler             = "apigateway.get_csv"
    lambda_zip_location = "outputs/apigateway.zip"
    runtime             = "python3.10"
  }
}

variable "file-name" {
  default = "etl.py"
}

variable "job-name" {
  default = "load-data-to-snowflake"
}

variable "job-language" {
  default = "3"
}

###################################################
#         Glue VARIABLES
###################################################
variable "glue_jar" {
  description = ".jar location"
  type = object({
    folder_path = string
    jdbc        = string
    spark       = string
  })
  default = {
    folder_path = "glue-jar"
    jdbc        = "snowflake-jdbc-3.13.30.jar"
    spark       = "spark-snowflake_2.12-2.11.0-spark_3.1.jar"
  }
}

variable "glue_crawler" {
  description = "Glue Crawler and database information"
  type = object({
    database_name = string
    crawler_name  = string
  })
  default = {
    database_name = "globant"
    crawler_name  = "dataeng-check-employees"
  }
}