#This needs to change for running
provider "aws" {
  region                  = "eu-west-2"
  shared_credentials_file = "/Users/Argedor/.aws/credentials"
  profile                 = "default"
}

#Calling the Dynamodb module to create a table and it's attributes
module "aws_dynamodb_module" {
    source = "./aws_dynamodb_module"
}

#Outputing table_name and hash_key from the Dynamodb Module
output "dynamodb_table_name" {
  value="${module.aws_dynamodb_module.dynamodb_name}"
}
output "dynamodb_hash_key" {
  value="${module.aws_dynamodb_module.dynamodb_hash_key}"
}
#Calling IAM Role Module to create the the rights for Lambda function to access Dynamo table created above
module "aws_iam_role_module" {
    source = "./aws_role_module"
    dynamo_db_arn = "${module.aws_dynamodb_module.dynamo_db_arn}"
}

#Calling the EC2 Module to create an ec2 instance with nginx server configured on it. Amiid can be changed as per need of the region
module "aws_ec2_module" {
    amiid = "ami-0194c3e07668a7e36"
    source= "./aws_ec2_module"
}

#Outputing the Public IP address of the EC2 Instance created above
output "instance_ip" {
  value="${module.aws_ec2_module.avengers_ec2_ip}"
}

#Calling the Lambda function Module to create lambda function to achieve the task logic
module "aws_lambda_module" {
    iam_role="${module.aws_iam_role_module.avengers_role_arn}"
    input_host="${module.aws_ec2_module.avengers_ec2_ip}"
    source= "./aws_lambda_module"
}

#Outputing the name of the Lambda function created above
output "lambda_function_name" {
  value="${module.aws_lambda_module.lambda_function_name}"
}
