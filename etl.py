import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
import boto3
import json
import csv

args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glue_context = GlueContext(sc)
spark = glue_context.spark_session
job = Job(glue_context)
logger = glue_context.get_logger()
job.init(args["JOB_NAME"], args)

# basic details
region_name = "us-west-2"
database = "globant"
jobs_table_name = "jobs"
departments_table_name = "departments"
employees_table_name = "employees"

# secret
session = boto3.session.Session()
client = session.client(
    service_name='secretsmanager',
    region_name=region_name
)
secret_response = client.get_secret_value(SecretId='snowflake-secrets')
snowflake_details = json.loads(secret_response['SecretString'])
secret_response1 = client.get_secret_value(SecretId='snowflake_login')
snowflake_details1 = json.loads(secret_response1['SecretString'])
logger.info(f"snowflake_details {snowflake_details}")

#snowflake connection
snowflake_options = {
    "sfUrl": snowflake_details['sfUrl'],
    "sfUser": snowflake_details1['sfUser'],
    "sfPassword": snowflake_details1['sfPassword'],
    "sfDatabase": snowflake_details['sfDatabase'],
    "sfSchema": snowflake_details['sfSchema'],
    "sfWarehouse": snowflake_details['sfWarehouse']
}

for table in [jobs_table_name, departments_table_name, employees_table_name]:
    df = None
    df = glue_context.create_dynamic_frame.from_catalog(
        database = database,
        table_name = table,
        transformation_ctx = "source1"
        )
    df =df.toDF()
    df.write.format("snowflake").options(**snowflake_options).option("dbtable", table).mode("overwrite").save()

job.commit()