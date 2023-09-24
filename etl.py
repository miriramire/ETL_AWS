import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from py4j.java_gateway import java_import

## @params: [JOB_NAME, URL, WAREHOUSE, DB, SCHEMA, USERNAME, PASSWORD]
SNOWFLAKE_SOURCE_NAME = "net.snowflake.spark.snowflake"
args = getResolvedOptions(sys.argv, ['JOB_NAME', 'URL', 'WAREHOUSE', 'DB', 'SCHEMA', 'USERNAME', 'PASSWORD'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)
java_import(spark._jvm, SNOWFLAKE_SOURCE_NAME)
## uj = sc._jvm.net.snowflake.spark.snowflake
spark._jvm.net.snowflake.spark.snowflake.SnowflakeConnectorUtils.enablePushdownSession(spark._jvm.org.apache.spark.sql.SparkSession.builder().getOrCreate())
sfOptions = {
"sfURL" : args['URL'],

"sfUser" : args['USERNAME'],
"sfPassword" : args['PASSWORD'],
"sfDatabase" : args['DB'],
"sfSchema" : args['SCHEMA'],
"sfWarehouse" : args['WAREHOUSE'],
"application" : "AWSGlue"
}

## Read from a Snowflake table into a Spark Data Frame
df = spark.read.format(SNOWFLAKE_SOURCE_NAME).options(**sfOptions).option("dbtable", "[table_name]").load()

## Perform any kind of transformations on your data and save as a new Data Frame: df1 = df.[Insert any filter, transformation, or other operation]
## Write the Data Frame contents back to Snowflake in a new table df1.write.format(SNOWFLAKE_SOURCE_NAME).options(**sfOptions).option("dbtable", "[new_table_name]").mode("overwrite").save() job.commit()