# avengers
Terraform Project

This project is designed to leverage serverless architecture (AWS Lambda Function) to check the status of an endpoint and feed data to a DynamoDB Table. If the function returns with an error, it automatically increases the error_count attribute in the table.
