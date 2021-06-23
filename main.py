import requests
import os 
import boto3
from botocore.exceptions import ClientError
from boto3.dynamodb.conditions import Key
import json

'''
Input_host= Takes the IP address of the newly created server from terraform apply and forwards to lambda using environment variables
table_name= Takes the name of the DynamoDB table created from terraform apply and forwards to lambda using environment variables
input_url= Represents end point for nginx server running on port 80
'''

input_host = os.environ['input_host']
table_name = os.environ['table_name']
input_url = "http://"+ input_host + "/"

'''
This function is to query the table in DynamoDB to check if the input url already exists
'''
def query_item(url:str, table_name:str):
    try:
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table(table_name)      
        
        response = table.query(
            KeyConditionExpression=Key('url').eq(url)
        )
    except ClientError as err:
        print("error = " + str(err))
    else:
        return response

'''
This function is to update the record in DynamoDB
'''

def update_record(url:str, error_count:int, table_name:str):
    dynamodb = boto3.resource('dynamodb')
    try:
        table = dynamodb.Table(table_name) 
        response = table.put_item(
            Item={
                "url": url,
                "error_count": error_count
            }
        )
    except ClientError as err:
        print(err)
    else:
        return response

'''
Main lambda function that handles the logic, checks the response from the URL,
inserts/updates the url and error_count value in the table
'''

def lambda_handler(event, context):
  resp= "Server not up"
  try:
    resp = requests.get(input_url)
    resp.raise_for_status()
    return {
        'statusCode': 200,
        'body': json.dumps("health check successful")
    }
  except (requests.exceptions.HTTPError, requests.exceptions.ConnectionError) as err:
    if len(query_item(input_url, table_name)['Items']) == 0:
      error_count = 1
      try:
        update_record(input_url, error_count, table_name)
        #return resp
        return {
        'statusCode': 200,
        'body': json.dumps(str("health check failed"))
    }
      except Exception as err:
        return {
        'statusCode': 400,
        'body': json.dumps(str(err))
    }
    else:
      query = query_item(input_url, table_name)
      error_count = query['Items'][0]['error_count'] + 1
      update_record(input_url, error_count, table_name)
      return {
        'statusCode': 200,
        'body': json.dumps(str("health check failed"))
    }
  except Exception as err:
    return {
        'statusCode': 400,
        'body': json.dumps(str(err))
    }