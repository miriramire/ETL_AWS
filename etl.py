from pyspark.context import SparkContext
from awsglue.context import GlueContext

# Initialize SparkContext and GlueContext
sc = SparkContext()
glueContext = GlueContext(sc)

db_name = "globant"
tbl_employees = "employees"
tbl_departments = "departments"
tbl_jobs = "jobs"

# Output directories
s3_directory = "landing-globant-data-terraform-project-101"
transformed_data = "transformed"
output_employees = f"{s3_directory}/{transformed_data}/{tbl_employees}"
output_departments = f"{s3_directory}/{transformed_data}/{tbl_departments}"
output_jobs = f"{s3_directory}/{transformed_data}/{tbl_jobs}"

# Dynamic frames creation 
employees = glueContext.create_dynamic_frame.from_catalog(database=db_name, table_name=tbl_employees)
departments = glueContext.create_dynamic_frame.from_catalog(database=db_name, table_name=tbl_departments)
jobs = glueContext.create_dynamic_frame.from_catalog(database=db_name, table_name=tbl_jobs)

# Write the transformed data to the specified S3 paths
employees.write.format('parquet').save(output_employees)
departments.write.format('parquet').save(output_departments)
jobs.write.format('parquet').save(output_jobs)