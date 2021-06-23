variable "iam_role" {}
variable "input_host" {}

resource "aws_cloudwatch_event_rule" "avengers_event" {
    name = "avengers-event"
    description = "avengers-event"
    schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "avengers_lambda_event_target" {
  rule = "${aws_cloudwatch_event_rule.avengers_event.name}"
  target_id = "InvokeLambda"
  arn = "${aws_lambda_function.avengers_lambda_function.arn}"
}

resource "aws_lambda_permission" "avengers_lambda_cloudwatch_permission" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.avengers_lambda_function.arn}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.avengers_event.arn}"
}

resource "aws_lambda_function" "avengers_lambda_function" {
    filename = "main.zip"
    function_name = "avengers_lambda"
    role =  "${var.iam_role}"
    handler = "main.lambda_handler"
    runtime = "python3.8"
    timeout = 15
    source_code_hash = "${filebase64sha256("main.zip")}"

    environment {
    variables = {
      input_host = "${var.input_host}",
      table_name = "avengers_table"
    }
  }

}

output "lambda_function_name" {
  value="${aws_lambda_function.avengers_lambda_function.function_name}"
}