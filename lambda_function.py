import json
import boto3
import glob
import snowflake.connector as sf
import os

def lambda_handler(event, context):
    url = 'https://de-materials-tpcds.s3.ca-central-1.amazonaws.com/inventory.csv'
    file_name = 'inventory.csv'
    local_file_path = '/tmp/inventory.csv'
    
    # Snowflake connection parameters from environment variables
    account = os.environ['SNOWFLAKE_ACCOUNT']
    warehouse = os.environ['SNOWFLAKE_WAREHOUSE']
    database = os.environ['SNOWFLAKE_DATABASE']
    schema = os.environ['SNOWFLAKE_SCHEMA']
    table = os.environ['SNOWFLAKE_TABLE']
    user = os.environ['SNOWFLAKE_USER']
    password = os.environ['SNOWFLAKE_PASSWORD']
    role = os.environ['SNOWFLAKE_ROLE']
    stage_name = os.environ['SNOWFLAKE_STAGE_NAME']
    
    s3 = boto3.client(
        's3',    
        aws_access_key_id=os.environ['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key=os.environ['AWS_SECRET_ACCESS_KEY']
    )
    
    try:
        s3.download_file(Bucket='de-materials-tpcds', Key=file_name, Filename=local_file_path, ExtraArgs={'RequestPayer': 'requester'})
        print(f"Downloaded {file_name} to {local_file_path}")
    except Exception as e:
        print(f"Error downloading file: {e}")
    
    files_in_tmp = glob.glob("/tmp/*")
    print(f"Files in /tmp/: {files_in_tmp}")
    
    # Establish Snowflake connection
    conn = sf.connect(user=user, password=password,
                      account=account, warehouse=warehouse,
                      database=database, schema=schema, role=role)

    cursor = conn.cursor()
    
    # Use schema
    use_schema = f"use schema {schema};"
    cursor.execute(use_schema)
    
    # Create CSV format
    create_csv_format = "CREATE or REPLACE FILE FORMAT COMMA_CSV TYPE ='CSV' FIELD_DELIMITER = ',';"
    cursor.execute(create_csv_format)
    
    create_stage_query = f"CREATE OR REPLACE STAGE {stage_name} FILE_FORMAT =COMMA_CSV"
    cursor.execute(create_stage_query)

    # Copy the file from local to the stage
    copy_into_stage_query = f"PUT 'file://{local_file_path}' @{stage_name}"
    cursor.execute(copy_into_stage_query)
    
    # List the stage
    list_stage_query = f"LIST @{stage_name}"
    cursor.execute(list_stage_query)
    
    # Truncate table
    truncate_table = f"truncate table {schema}.{table};"  
    cursor.execute(truncate_table)    

    # Load the data from the stage into a table
    copy_into_query = f"COPY INTO {schema}.{table} FROM @{stage_name}/{file_name} FILE_FORMAT =COMMA_CSV;"  
    cursor.execute(copy_into_query)

    print("File uploaded to Snowflake successfully.")

    return {
        'statusCode': 200,
        'body': 'File downloaded and uploaded to Snowflake successfully.'
    }