variable "s3_bucket_landing" {
  description = "External data will be received in input folder"
  type = object({
    name    = string
    employees   = string
    departments  = string
    jobs = string
    tranformed = string
    python_code = string
    etl = string
  })

  default = {
    name        = "landing-globant-data-terraform-project-101"
    employees   = "employees"
    departments = "departments"
    jobs        = "jobs"
    tranformed  = "transformed"
    python_code = "python"
    etl = "etl.py"
  }
}