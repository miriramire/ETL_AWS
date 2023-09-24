import pandas as pd
import boto3
import io

from datetime import datetime

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    # Getting Bucket name and key
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    
    # getting content as STR
    response = s3_client.get_object(Bucket=bucket, Key=key)
    content = response['Body'].read().decode('utf-8')
    
    # Retrieve the Pandas Data
    df = pd.read_excel(
            content,
            engine='openpyxl', 
            index_col=None, 
            header=None
        )

    csv_buffer = io.StringIO()
    df.to_csv(csv_buffer, index=False, header=False)

    # Specify the S3 bucket and key where you want to save the modified JSON
    new_bucket = f"{bucket}-transformed"
    new_key = key.replace("xlsx", "csv")

    # Upload the modified JSON to S3
    s3_client.put_object(Bucket=new_bucket, Key=new_key, Body=csv_buffer.getvalue())

    return {
        'statusCode': 200,
        'body': "CSV file saved and uploaded to S3 successfully."
    }