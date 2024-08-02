import json
import boto3
import csv
import uuid
from io import StringIO

s3 = boto3.client('s3')

def get_csv(event, context):
    try:
        body = event['body']
        csv_content = json.loads(body)['csv_content']
        bucket_name = 'landing-globant-data-terraform-project-101'
        file_key = str(uuid.uuid4()) + '.csv'

        # Upload CSV content to S3
        s3.put_object(Bucket=bucket_name, Key=file_key, Body=csv_content.encode('utf-8'))

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'CSV file uploaded to S3',
                'bucket': bucket_name,
                'file_key': file_key
            })
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error uploading CSV file to S3: {str(e)}')
        }