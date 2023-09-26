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
    source_file = string
    function_name = string
    handler = string
    lambda_zip_location = string
    runtime = string
    pandas = string
  })

  default = {
    source_file = "lambdafunc.py"
    function_name = "lambdafunc"
    handler = "lambdafunc.lambda_handler"
    lambda_zip_location = "outputs/lambdafunc.zip"
    runtime = "python3.10"
    pandas = "pandas_layer.zip"
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

variable "glue_jar" {
  description = ".jar location"
  type = object({
    folder_path = string
    jdbc        = string
    spark       = string
  })
  default = {
    folder_path = "glue-jar"
    jdbc = "snowflake-jdbc-3.14.1.jar"
    spark = "spark-snowflake_2.13-2.12.0-spark_3.4.jar"
  }
}