#Terraform Project#

This project is designed to leverage serverless architecture (AWS Lambda Function) to check the status of an endpoint and feed data to a *DynamoDB Table*. If the function returns with an error, it automatically increases the *error_count* attribute in the table.

The project uses *Terraform (IaC)* to create all the necessary resources in AWS to perform it's function. As an examplary placeholder application, it deploys an EC2 instance and installs *Nginx server* on it. 

##How does it work?##

There are 4 modules created seperately to achieve this task, the purpose of this was to create decoupled architecture that can be further developed or reduced as per needs

1. AWS DynamoDB Module
   - Creates the DynamoDB table with the desired specifications
   - Outputs:
     - Name of the DynamoDB Table
     - Hash_key of the DynamoDB Tables
     - ARN of the DynamoDB Table

2. AWS EC2 Module
   - Creates the EC2 with the desired specificaitons and installs Nginx server on it using userdata.sh script in the main folder
   - Inputs:
     - AMI-ID of a Ubuntu 20.04 Machine
   - Outputs:
     - The Public IP Address of the Server

3. AWS Role Module
   - Creates the IAM Role Policy and the IAM Role necessary to provide permissions for Lambda Function to execucutes the logic
   - Inputs:
     - The ARN of DynamoDB Table created using the DynamoDB Module
     - This is important, as we restrict our Lambda function to achieve it's task with the least priviledges
   - Outputs:
     - The ARN of the IAM Role created

4. AWS Lambda Module
   - Creates a Python Lambda function using the code logic in *main.py* with it's dependencies and code inside the *main.zip* file
   - The Lambda function is designed to get invoked every 5 minutes by using *CloudWatch Event Rule*
   - Inputs as Environment Variables:
     - IAM Role created in AWS Role Module
     - The Public IP Address of created in the EC2 Module which holds our placeholder application i-e *Nginx Server*
   - Outputs:
     - Name of the Lambda Function


##How to make it work?##
1. Edit main.tf to with a desrired region, profile and credentials file path.
2. Edit the AMIID *amiid* input in the main.tf file for the *aws_ec2_module*
3. To add an SSH key to the EC2 server, unedit the *key_name* parameter in *ec2_module.tf* to a valid key
4. After making the necessary changes, in the cloned directory run *Terraform apply*



