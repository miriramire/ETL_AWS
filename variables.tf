variable "s3_bucket_landing" {
  description = "External data will be received in input folder"
  type = object({
    name    = string
    employees   = string
    departments  = string
    jobs = string
    tranformed = string
    python_code = string
  })

  default = {
    name        = "landing-globant-data-terraform-project-101"
    employees   = "employees"
    departments = "departments"
    jobs        = "jobs"
    tranformed  = "transformed"
    python_code = "python"
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