variable "s3_bucket_landing" {
  description = "External data will be received in input folder"
  type = object({
    name    = string
    employees   = string
    departments  = string
    jobs = string
    python_code = string
  })

  default = {
    name        = "landing-globant-data-terraform-project-101"
    employees   = "employees"
    departments = "departments"
    jobs        = "jobs"
    python_code = "python"
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
  })

  default = {
    source_file = "lambdafunc.py"
    function_name = "lambdafunc"
    handler = "lambdafunc.lambda_handler"
    lambda_zip_location = "outputs/lambdafunc.zip"
    runtime = "python3.10"
  }
  
}

variable "file-name" {
  default = "etl.py"
}

variable "job-name" {
  default = "load-data-to-redshift"
}

variable "job-language" {
  default = "python"
}